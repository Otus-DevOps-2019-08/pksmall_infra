resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  machine_type = var.mach_type
  zone         = var.zone
  count        = "1"

  tags = ["reddit-app", "http-server"]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  }
}

resource "null_resource" "app" {
  count        = var.enable_provision ? "1" : "0"

  connection {
    type        = "ssh"
    host        = google_compute_address.app_ip.address
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source = "files/gensysd.py"
    destination = "/tmp/gensysd.py"
  }
  provisioner "file" {
    source = "${path.module}/files/set_env.sh"
    destination = "/tmp/set_env.sh"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "ls -la /tmp",
      "/bin/chmod +x /tmp/set_env.sh",
      "/tmp/set_env.sh ${var.database_url}",
      "chmod +x /tmp/gensysd.py",
      "sudo -H /tmp/gensysd.py",
      "ps xau | grep puma"
    ]
  }
}


resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80", "9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
