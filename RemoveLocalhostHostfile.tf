#
# Remove named 127.0.0.1 entry
#

resource "null_resource" "controller-removelocalhost-hostfile" {

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts"
    ]
  }
}

resource "null_resource" "dashboard-removelocalhost-hostfile" {

  connection {
    host = "${packet_device.dashboard.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts"
    ]
  }
}

resource "null_resource" "compute-x86-removelocalhost-hostfile" {

  count = "${var.openstack_compute-x86_count}"

  connection {
    host = "${element(packet_device.compute-x86.*.access_public_ipv4, count.index)}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts"
    ]
  }
}

resource "null_resource" "compute-arm-removelocalhost-hostfile" {

  count = "${var.openstack_compute-arm_count}"

  connection {
    host = "${element(packet_device.compute-arm.*.access_public_ipv4, count.index)}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts"
    ]
  }
}
