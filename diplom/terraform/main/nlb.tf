resource "yandex_lb_target_group" "lb_tg" {
  name = "loadbalancer-tg"

  target {
    subnet_id = "${yandex_vpc_subnet.sub-a.id}"
    address   = "${yandex_compute_instance.master.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.sub-a.id}"
    address   = "${yandex_compute_instance.n01.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.sub-b.id}"
    address   = "${yandex_compute_instance.n02.network_interface.0.ip_address}"
  }

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.n01,
    yandex_compute_instance.n02
  ]

}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "loadbalancer"

  listener {
    name         = "grafana-listener"
    port         = 3000
    target_port  = 30090
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "myapp-listener"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "atlantis-listener"
    port        = 4141
    target_port = 30041
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb_tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 30080
        path = "/"
      }
    }
  }
}
