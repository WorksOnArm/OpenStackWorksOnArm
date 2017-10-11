
resource "null_resource" "controller-keystone" {
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

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ControllerKeystone.sh > ControllerKeystone.out",
    ]
  }
}

resource "null_resource" "controller-glance" {

  depends_on = ["null_resource.controller-keystone"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "ControllerGlance.sh"
    destination = "ControllerGlance.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerGlance.sh > ControllerGlance.out",
    ]
  }
}

resource "null_resource" "controller-nova" {

  depends_on = ["null_resource.controller-keystone"]
  depends_on = ["null_resource.controller-glance"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
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
      "bash ControllerNova.sh > ControllerNova.out",
      "bash ControllerNeutron.sh > ControllerNeutron.out",
    ]
  }
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
