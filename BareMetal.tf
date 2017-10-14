provider "packet" {
  auth_token = "${var.packet_auth_token}"
}

resource "packet_device" "controller" {
  hostname = "controller"
  tags     = ["openstack-${random_id.cloud.hex}"]

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
  tags     = ["openstack-${random_id.cloud.hex} "]

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

resource "packet_device" "compute-x86" {
  hostname = "${format("compute-x86-%02d", count.index)}"
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = "${var.openstack_compute-x86_count}"

  operating_system = "ubuntu_16_04"
  plan             = "${var.packet_compute-x86_type}"
  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"
}

resource "packet_device" "compute-arm" {
  hostname = "${format("compute-arm-%02d", count.index)}"
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = "${var.openstack_compute-arm_count}"

  operating_system = "ubuntu_16_04"
  plan             = "${var.packet_compute-arm_type}"
  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facility      = "${var.packet_facility}"
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"
}

