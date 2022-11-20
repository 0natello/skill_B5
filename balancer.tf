resource "yandex_lb_network_load_balancer" "cloud-terraform" {
  name = "internal-lb-aionov"
  
  listener {
    name = "my-listener"
    port = 8080
    internal_address_spec {
      subnet_id  = "${yandex_vpc_subnet.subnet-1.id}"
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.aionov-1.load_balancer.0.target_group_id
    
    healthcheck {
      name = "http"
      http_options {
          port = 8080
          path = "/ping"
      }
    }
  }
}