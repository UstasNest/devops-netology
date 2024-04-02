# пустая VPC
resource "yandex_vpc_network" "net" {
  name = "network"
}

# Создать в VPC subnet, зона a
resource "yandex_vpc_subnet" "sub-a" {
  name = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создать в VPC subnet, зона b 
resource "yandex_vpc_subnet" "sub-b" {
  name           = "subnet-b"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.net.id}"
}

