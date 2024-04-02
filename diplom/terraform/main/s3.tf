terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "my-diplom-bucket"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

