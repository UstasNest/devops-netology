provider "yandex" {
  cloud_id  = "b1grn553i4jliur438sh"
  folder_id = "b1gr8f0k0vi2jeh5clg6"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "img" {
  name       = "img"
  source_image = "fd80le4b8gt2u33lvubr"
}

resource "yandex_compute_instance" "vm-count" {
  count = local.instance_count[terraform.workspace]
  name = "${terraform.workspace}-vm-count-${count.index}"

  resources {
    cores  = local.vm_cores[terraform.workspace]
    memory = local.vm_memory[terraform.workspace]
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub1.id}"
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.img.id}"
    }
  }
  lifecycle {
    create_before_destroy = true
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

resource "yandex_compute_instance" "vm-foreach" {

  for_each = local.vm_foreach[terraform.workspace]
  name = "${terraform.workspace}-foreach-${each.key}"

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.sub1.id}"
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.img.id}"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  instance_count = {
    "prod"=2
    "stage"=1
  }
  vm_cores = {
    "prod"=4
    "stage"=2
  }
  vm_memory = {
    "prod"=4
    "stage"=2
  }
  vm_foreach = {
    prod = {
      "3" = { cores = "4", memory = "4" },
      "2" = { cores = "4", memory = "4" }
    }
    stage = {
      "1" = { cores = "2", memory = "2" }
    }
  }
}