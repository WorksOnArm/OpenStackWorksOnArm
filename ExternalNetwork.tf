
resource "null_resource" "controller-external-network" {
  depends_on = ["null_resource.controller-openstack"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "file" {
    source      = "ExternalNetwork.sh"
    destination = "ExternalNetwork.sh"
  }
}

