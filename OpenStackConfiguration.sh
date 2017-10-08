. admin-openrc 

# Download ARM images and upload into OpenStack (Glance)

IMG_URL=https://dl.fedoraproject.org/pub/fedora-secondary/releases/26/CloudImages/aarch64/images/Fedora-Cloud-Base-26-1.5.aarch64.qcow2
IMG_NAME=Fedora-26-arm64
OS_DISTRO=fedora
wget -q -O - $IMG_URL | \
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME --property hw_firmware_type=uefi \
	--visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress

IMG_URL=https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-arm64.tar.gz
IMG_NAME=xenial-server-arm64
OS_DISTRO=ubuntu
wget $IMG_URL
tar xfvz ubuntu-16.04-server-cloudimg-arm64.tar.gz xenial-server-cloudimg-arm64.img
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME --file xenial-server-cloudimg-arm64.img \
	--property hw_firmware_type=uefi \
	--visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress
rm xenial-server-cloudimg-arm64.img
rm ubuntu-16.04-server-cloudimg-arm64.tar.gz

# some default flavors
openstack flavor create --ram 512   --disk 1   --vcpus 1 m1.tiny
openstack flavor create --ram 2048  --disk 20  --vcpus 1 m1.small
openstack flavor create --ram 4096  --disk 40  --vcpus 2 m1.medium
openstack flavor create --ram 8192  --disk 80  --vcpus 4 m1.large
openstack flavor create --ram 16384 --disk 160 --vcpus 8 m1.xlarge

