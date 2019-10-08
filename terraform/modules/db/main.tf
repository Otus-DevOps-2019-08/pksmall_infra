resource "google_compute_instance" "db" {
  name         = "reddit-db-${count.index}"
  machine_type = var.mach_type
  zone         = var.zone
  count        = "1"

  tags = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  }

/*  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/gensysd.py"
    destination = "/tmp/gensysd.py"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "ls -la /tmp",
      "chmod +x /tmp/gensysd.py",
      "sudo -H /tmp/gensysd.py",
      "ps xau | grep puma"
    ]
  }*/
}

# Правило firewall
resource "google_compute_firewall" "firewall_mongo" {
  name = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
