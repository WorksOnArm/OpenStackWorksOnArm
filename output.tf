output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Controller Type" {
  value = "${packet_device.controller.plan}"
}

output "Compute x86 Type" {
  value = "${packet_device.compute-x86.plan}"
}

output "Compute ARM Type" {
  value = "${packet_device.compute-arm.plan}"
}

output "Compute x86 IPs" {
  value = "${packet_device.compute-x86.*.access_public_ipv4}"
}

output "Compute ARM IPs" {
  value = "${packet_device.compute-arm.*.access_public_ipv4}"
}

output "Horizon dashboard via IP" {
  value = "http://${packet_device.dashboard.access_public_ipv4}/horizon/ admin/ADMIN_PASS"
}

output "Controller SSH" {
  value = "ssh root@${packet_device.controller.access_public_ipv4} -i ${var.cloud_ssh_key_path}"
}

#output "Horizon dashboard via DNS" {
#  value = "http://${dnsimple_record.dashboard-dns.hostname}/horizon/ admin/ADMIN_PASS"
#}
#
#output "Controller SSH via DNS" {
#  value = "ssh root@${dnsimple_record.controller-dns.hostname} -i ${var.cloud_ssh_key_path}"
#}
