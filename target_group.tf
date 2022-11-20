resource "yandex_lb_target_group" "aionov-1" {
  name      = "my-target-group"

  target {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    address   = "192.168.10.*"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    address   = "192.168.10.*"
  }

}