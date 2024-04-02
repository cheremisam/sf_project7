terraform {
  required_version = "1.5.7"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.112.0"
    }
  }

}

# Документация к провайдеру тут https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs#configuration-reference
# Настраиваем the Yandex.Cloud provider
provider "yandex" {
  service_account_key_file = file("sa.json")
  cloud_id                 = "b1gplktasqvig8ni6vo5"
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "terraform-network" {
  name      = "terraform-network"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.terraform-network.id
  folder_id      = var.folder_id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

data "yandex_compute_image" "my_image" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name        = "docker"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/artemYandexCloud.pub")}"    
  }
}