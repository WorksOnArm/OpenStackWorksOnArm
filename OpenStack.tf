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

resource "null_resource" "controller-openstack" {
  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "file" {
    source      = "ControllerKeystone.sh"
    destination = "ControllerKeystone.sh"
  }

  provisioner "file" {
    source      = "ControllerGlance.sh"
    destination = "ControllerGlance.sh"
  }

  provisioner "file" {
    source      = "ControllerNova.sh"
    destination  = "ControllerNova.sh"
  }

  provisioner "file" {
    source      = "ControllerNeutron.sh"
    destination = "ControllerNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ControllerKeystone.sh > ControllerKeystone.out",
      "bash ControllerGlance.sh > ControllerGlance.out",
      "bash ControllerNova.sh > ControllerNova.out",
      "bash ControllerNeutron.sh > ControllerNeutron.out",
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

resource "null_resource" "dashboard-openstack" {

  connection {
    host = "${packet_device.dashboard.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${packet_device.controller.access_private_ipv4} ${packet_device.controller.hostname} >> /etc/hosts",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y install openstack-dashboard",
    ]
  }

  provisioner "file" {
    source      = "local_settings.py"
    destination = "/etc/openstack-dashboard/local_settings.py"
  }


  provisioner "remote-exec" {
    inline = [
      "service apache2 reload"
    ]
  }

}

# save the dashboard IP in the controller host file
resource "null_resource" "dashboard-controller-hostname" {
  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${packet_device.dashboard.access_private_ipv4} ${packet_device.dashboard.hostname} >> /etc/hosts",
    ]
  }
}

# save the compute IP in the controller host file
resource "null_resource" "compute-controller-hostname" {
  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  count = "${var.openstack_compute_count}"

  provisioner "remote-exec" {
    inline = [
      "echo ${element(packet_device.compute.*.access_private_ipv4, count.index)} ${element(packet_device.compute.*.hostname, count.index)} >> /etc/hosts",
    ]
  }
}


resource "null_resource" "compute-openstack" {
  count = "${var.openstack_compute_count}"

  connection {
    host = "${element(packet_device.compute.*.access_public_ipv4, count.index)}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "file" {
    source      = "ComputeNova.sh"
    destination = "ComputeNova.sh"
  }

  provisioner "file" {
    source      = "ComputeNeutron.sh"
    destination = "ComputeNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${packet_device.controller.access_private_ipv4} ${packet_device.controller.hostname} >> /etc/hosts",
      "echo ${element(packet_device.compute.*.access_private_ipv4, count.index)} ${element(packet_device.compute.*.hostname, count.index)} >> /etc/hosts",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ComputeNova.sh > ComputeNova.out",
      "bash ComputeNeutron.sh > ComputeNeutron.out",
    ]
  }
}
