
#
# load up the OpenStack cloud with some default settings and images
#

resource "null_resource" "openstack-images" {

  depends_on = ["null_resource.controller-glance"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "DefaultOpenStackImages.sh"
    destination = "DefaultOpenStackImages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash DefaultOpenStackImages.sh > DefaultOpenStackImages.out",
    ]
  }
}

resource "null_resource" "openstack-flavors" {

  depends_on = ["null_resource.controller-nova"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "DefaultOpenStackFlavors.sh"
    destination = "DefaultOpenStackFlavors.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash DefaultOpenStackFlavors.sh > DefaultOpenStackFlavors.out",
    ]
  }
}
