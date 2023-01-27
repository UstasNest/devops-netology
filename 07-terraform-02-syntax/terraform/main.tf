provider "yandex" {
  cloud_id  = "b1grn553i4jliur438sh"
  folder_id = "b1gr8f0k0vi2jeh5clg6"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "img" {
  name       = "img"
  source_image = "fd80le4b8gt2u33lvubr"
}

resource "yandex_compute_instance" "vm" {
  name = "my-vm"

  resources {
    cores  = 2
    memory = 4
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub1.id}"
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.img.id}"
    }
  }
}

resource "yandex_vpc_network" "net1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "sub1" {
  name = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.net1.id}"
  v4_cidr_blocks = ["10.11.1.0/24"]
}