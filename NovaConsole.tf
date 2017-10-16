
#
# serial console required for ARM systems
#

resource "null_resource" "novaconsole" {

  depends_on = ["null_resource.controller-openstack"]

  connection {
    host = "${packet_device.controller.access_public_ipv4}"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install -y git",
      "git clone http://github.com/larsks/novaconsole.git",
      "cd novaconsole",
      "python setup.py install",
    ]
  }
}
