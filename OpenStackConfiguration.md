

Steps required to configure OpenStack for use with ARM systems.


* Download ARM images
* Upload/Configure ARM images into Glance
* Install ARM firmware
(apt-get install qemu-efi)
* Setup provider network
* Create public (virtual) network
* Create internal (virtual) network
* Setup virtual machines and applications




openstack network create  --share --external \
  --provider-physical-network provider \
  --provider-network-type flat provider


# replace IP addresses with public IP addresses provided by Packet
openstack subnet create --network provider \
  --allocation-pool start=10.64.67.10,end=10.64.67.14 \
  --dns-nameserver 8.8.4.4 --gateway 10.64.67.9 \
  --subnet-range 10.64.67.8/29 provider

openstack router create provider-gw
openstack router set --external-gateway provider provider-gw


openstack network create internal
openstack subnet create  --dhcp --network internal --allocation-pool start=192.168.100.100,end=192.168.100.200 --subnet-range 192.168.100.0/24 internal
openstack router create internal-gw
openstack router add subnet internal-gw internal
openstack router set --external-gateway provider  internal-gw



openstack keypair create default > default.pem
openstack server create --flavor m1.small --image ubuntu-xenial-arm64 --key-name default --network provider ubuntu
