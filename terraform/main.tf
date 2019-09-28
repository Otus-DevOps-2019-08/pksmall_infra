terraform {
  # Версия terraform
  required_version = "~> 0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "2.15"
  # ID проекта
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "puma-app2" {
  name         = "puma-app2"
  machine_type = "g1-small"
  zone         = var.zone

  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "reddit-base"
      size  = "10"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  }

  connection {
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
  }
}

resource "google_compute_instance" "puma-app" {
  name         = "puma-app"
  machine_type = "g1-small"
  zone         = var.zone

  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "reddit-base"
      size  = "10"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  }

  connection {
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
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}


resource "google_compute_project_metadata_item" "default" {
  key = "ssh-keys"
  value = "appuser_web:${file(var.public_key_path)}"
}
