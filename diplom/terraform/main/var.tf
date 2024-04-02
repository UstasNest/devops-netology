provider "yandex" {
  cloud_id  = "b1grn553i4jliur438sh"
  folder_id = "b1gr8f0k0vi2jeh5clg6"
  zone      = "ru-central1-a"
}

variable "ip" {
  default = "../../ansible/group_vars/all/ip.yml"
}

#Ubuntu-2204-lts
variable "img" {
  default = "fd8r9ntkrnrn46fkh0e4"
}

