provider "packet" {
  auth_token = "${var.packet_api_key}"
}

resource "packet_device" "controller" {
  hostname = "controller"

  operating_system = "ubuntu_16_04"
  plan             = "${var.packet_controller_type}"
  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  public_ipv4_subnet_size  = "29"

  provisioner "remote-exec" {
    inline = [
      "echo ${packet_device.controller.access_private_ipv4} ${packet_device.controller.hostname} >> /etc/hosts"
    ]
  }
}

resource "packet_device" "dashboard" {
  hostname = "dashboard"

  operating_system = "ubuntu_16_04"
  plan             = "${var.packet_dashboard_type}"
  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""

  facility      = "${var.packet_facility}"
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"
}

resource "packet_device" "compute" {
  hostname = "${format("compute-%02d", count.index)}"

  count = "${var.openstack_compute_count}"

  operating_system = "ubuntu_16_04"
  plan             = "${var.packet_compute_type}"
  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"
}
