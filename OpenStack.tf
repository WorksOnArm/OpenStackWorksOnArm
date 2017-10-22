
resource "random_id" "cloud" {
  byte_length = 4
}

resource "null_resource" "controller-openstack" {
  depends_on = ["null_resource.hostfile-distributed"]

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

  provisioner "file" {
    source      = "ControllerGlance.sh"
    destination = "ControllerGlance.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerGlance.sh > ControllerGlance.out",
    ]
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
      "bash ControllerNova.sh ${packet_device.controller.access_public_ipv4} > ControllerNova.out",
      "bash ControllerNeutron.sh > ControllerNeutron.out",
    ]
  }
}

resource "null_resource" "dashboard-openstack" {
  depends_on = ["null_resource.hostfile-distributed"]

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
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y install openstack-dashboard > Dashboard.out",
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

resource "null_resource" "compute-x86-openstack" {
  depends_on = ["null_resource.hostfile-distributed"]

  count = "${var.openstack_compute-x86_count}"

  connection {
    host = "${element(packet_device.compute-x86.*.access_public_ipv4, count.index)}"
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
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ComputeNova.sh ${packet_device.controller.access_public_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh > ComputeNeutron.out",
    ]
  }
}

resource "null_resource" "compute-arm-openstack" {
  depends_on = ["null_resource.hostfile-distributed"]

  count = "${var.openstack_compute-arm_count}"

  connection {
    host = "${element(packet_device.compute-arm.*.access_public_ipv4, count.index)}"
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
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ComputeNova.sh ${packet_device.controller.access_public_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh > ComputeNeutron.out",
    ]
  }
}

