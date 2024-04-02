# вывод адресов
output "master_external_ip_address" {
  value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

output "master_internal_ip_address" {
  value = yandex_compute_instance.master.network_interface.0.ip_address
}

# 01

output "node01_external_ip_address" {
  value = yandex_compute_instance.n01.network_interface.0.nat_ip_address
}

output "node01_internal_ip_address" {
  value = yandex_compute_instance.n01.network_interface.0.ip_address
}

# 02

output "node02_external_ip_address" {
  value = yandex_compute_instance.n02.network_interface.0.nat_ip_address
}

output "node02_internal_ip_address" {
  value = yandex_compute_instance.n02.network_interface.0.ip_address
}

output "lb_ip_address" {
  value = "${[for s in yandex_lb_network_load_balancer.lb.listener: s.external_address_spec.*.address].0[0]}" 
}
resource "null_resource" "ip" {

  provisioner "local-exec" {
    command = "echo --- > ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo MASTER_EXT_IP: ${yandex_compute_instance.master.network_interface.0.nat_ip_address} >> ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo MASTER_INT_IP: ${yandex_compute_instance.master.network_interface.0.ip_address} >> ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo N01_EXT_IP: ${yandex_compute_instance.n01.network_interface.0.nat_ip_address} >> ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo N01_INT_IP: ${yandex_compute_instance.n01.network_interface.0.ip_address} >> ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo N02_EXT_IP: ${yandex_compute_instance.n02.network_interface.0.nat_ip_address} >> ${var.ip}" 
  }

  provisioner "local-exec" {
    command = "echo N02_INT_IP: ${yandex_compute_instance.n02.network_interface.0.ip_address} >> ${var.ip}"
  }

  provisioner "local-exec" {
    command = "echo NLB_EXT_IP: ${[for s in yandex_lb_network_load_balancer.lb.listener: s.external_address_spec.*.address].0[0]} >> ${var.ip}"
  }

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.n01,
    yandex_compute_instance.n02
  ]
}

