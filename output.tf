output "Horizon dashboard available at" {
  value = "http://${packet_device.dashboard.access_public_ipv4}/horizon/ admin/ADMIN_PASS"
}

output "Controller SSH" {
  value = "ssh root@${packet_device.controller.access_public_ipv4} -i ${var.cloud_ssh_key_path}"
}
