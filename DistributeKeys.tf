
#
# copy the keys over to the controller to allow SSH access to the other nodes
#

resource "null_resource" "controller-distribute-keys" {

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "${file("${var.cloud_ssh_key_path}")}"
    destination = "openstack_rsa"
  }

  provisioner "file" {
    source      = "${file("${var.cloud_ssh_public_key_path}")}"
    destination = "openstack_rsa.pub"
  }

}
