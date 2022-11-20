terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0_AgAAAAAIU9bEAATuwQAAAADT4fD7D9rB-TcCTOe0pzJxCvo3hwmviNM"
  cloud_id  = "dn2qtphlmn39aqbj4f98"
  folder_id = "b1g1tlqv0fvid7ql562c"
  zone = "ru-central1-a"
}

resource "yandex_compute_instance_group" "aionov-1" {
  name               = "fixed-ig-with-balancer"
  folder_id          = "b1g1tlqv0fvid7ql562c"
  service_account_id = "aje6ciu80gds8r616jrq"
  instance_template {
    platform_id = "standard-v3"
    resources {
      core_fraction = 20
      memory = 1
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8kdnltr2353cirte81"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.network-1.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet-1.id}"]
      nat = true
    }

    metadata = {
      user-data = "${file("/home/user/terraform/yandex/user.txt")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
    }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
