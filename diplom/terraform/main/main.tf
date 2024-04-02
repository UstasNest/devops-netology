# Создать VM

resource "yandex_compute_instance" "master" {
  name     = "master"
  hostname = "master"
  zone     = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub-a.id}"
    nat = true
  }

  boot_disk {
    initialize_params {
      image_id = var.img
      name     = "master-disk"
      type     = "network-nvme"
      size     = "30"
    }
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

# копируем приватный ключ на ВМ, чтобы потом можно было с нее подключаться
  provisioner "file" {
    source      = pathexpand("~/.ssh/id_rsa")
    destination = pathexpand("~/.ssh/id_rsa")
    connection {
      type        = "ssh"
      host        = self.network_interface.0.nat_ip_address
      user        = "vagrant"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface.0.nat_ip_address
      user        = "vagrant"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

# создать вируталки для нод

resource "yandex_compute_instance" "n01" {
  name     = "node01"
  hostname = "node01"
  zone     = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub-a.id}"
    nat = true
  }

  boot_disk {
    initialize_params {
      image_id = var.img
      name     = "node01-disk"
      type     = "network-nvme"
      size     = "20"
    }
  }  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "n02" {
  name     = "node02"
  hostname = "node02"
  zone     = "ru-central1-b"
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub-b.id}"
    nat = true
  }

  boot_disk {
    initialize_params {
      image_id = var.img
      name     = "node02-disk"
      type     = "network-nvme"
      size     = "20"
    }
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

