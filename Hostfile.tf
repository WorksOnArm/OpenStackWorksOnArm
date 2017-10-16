#
# Setup /etc/hosts across all nodes
#

resource "null_resource" "blank-hostfile" {

  provisioner "local-exec" {
    command = "rm -f hostfile"
  }

}

#
# gather the IP address from all the nodes
#
resource "null_resource" "controller-generate-hostfile" {
  depends_on = ["null_resource.blank-hostfile"]

  provisioner "local-exec" {
    command =
      "echo ${packet_device.controller.access_private_ipv4} ${packet_device.controller.hostname} >> hostfile"
  }
}

resource "null_resource" "dashboard-generate-hostfile" {
  depends_on = ["null_resource.blank-hostfile"]

  provisioner "local-exec" {
    command = 
      "echo ${packet_device.dashboard.access_private_ipv4} ${packet_device.dashboard.hostname} >> hostfile"
  }
}

resource "null_resource" "compute-x86-generate-hostfile" {
  depends_on = ["null_resource.blank-hostfile"]

  count = "${var.openstack_compute-x86_count}"

  provisioner "local-exec" {
    command =
      "echo ${element(packet_device.compute-x86.*.access_private_ipv4, count.index)} ${element(packet_device.compute-x86.*.hostname, count.index)} >> hostfile"
  }

}

resource "null_resource" "compute-arm-generate-hostfile" {
  depends_on = ["null_resource.blank-hostfile"]

  count = "${var.openstack_compute-arm_count}"

  provisioner "local-exec" {
    command = 
      "echo ${element(packet_device.compute-arm.*.access_private_ipv4, count.index)} ${element(packet_device.compute-arm.*.hostname, count.index)} >> hostfile"
  }

}

#
# checkpoint
#
resource "null_resource" "hostfile-generated" {
  depends_on = ["null_resource.controller-generate-hostfile",
		"null_resource.dashboard-generate-hostfile",
		"null_resource.compute-x86-generate-hostfile",
		"null_resource.compute-arm-generate-hostfile"]
}

#
# write out the hosts onto the nodes
#
resource "null_resource" "controller-write-hostfile" {
  depends_on = ["null_resource.hostfile-generated"]

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
      "cat hostfile >> /etc/hosts"
    ]
  }
}

resource "null_resource" "dashboard-write-hostfile" {
  depends_on = ["null_resource.hostfile-generated"]

  connection {
    host = "${packet_device.dashboard.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts"
    ]
  }
}

resource "null_resource" "compute-x86-write-hostfile" {
  depends_on = ["null_resource.hostfile-generated"]

  count = "${var.openstack_compute-x86_count}"

  connection {
    host = "${element(packet_device.compute-x86.*.access_public_ipv4, count.index)}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts"
    ]
  }
}

resource "null_resource" "compute-arm-write-hostfile" {
  depends_on = ["null_resource.hostfile-generated"]

  count = "${var.openstack_compute-arm_count}"

  connection {
    host = "${element(packet_device.compute-x86.*.access_public_ipv4, count.index)}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts"
    ]
  }
}

# checkpoint
resource "null_resource" "hostfile-distributed" {
  depends_on = ["null_resource.controller-write-hostfile",
		"null_resource.dashboard-write-hostfile",
		"null_resource.compute-x86-write-hostfile",
		"null_resource.compute-arm-write-hostfile"]

  provisioner "local-exec" {
    command = 
      "echo all systems have updated hostfile"
  }
}

