export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

# Download ARM images and upload into OpenStack (Glance)

IMG_URL=https://dl.fedoraproject.org/pub/fedora-secondary/releases/26/CloudImages/aarch64/images/Fedora-Cloud-Base-26-1.5.aarch64.qcow2
IMG_NAME=Fedora-26-arm64
OS_DISTRO=fedora
wget -q -O - $IMG_URL | \
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME --property hw_firmware_type=uefi \
	--visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress

IMG_URL=https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-arm64.tar.gz
IMG_NAME=xenial-arm64
OS_DISTRO=ubuntu
wget $IMG_URL
tar xfvz ubuntu-16.04-server-cloudimg-arm64.tar.gz xenial-server-cloudimg-arm64.img
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME --file xenial-server-cloudimg-arm64.img \
	--property hw_firmware_type=uefi \
	--visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress
rm xenial-server-cloudimg-arm64.img
rm ubuntu-16.04-server-cloudimg-arm64.tar.gz

IMG_URL=https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
IMG_NAME=CentOS-7-x86_64
OS_DISTRO=centos
wget -q -O - $IMG_URL | \
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME \
        --visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress

IMG_URL=http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
IMG_NAME=cirros-x86_64
OS_DISTRO=cirros
wget -q -O - $IMG_URL | \
glance  --os-image-api-version 2 image-create --protected True --name $IMG_NAME \
        --visibility public --disk-format raw --container-format bare --property os_distro=$OS_DISTRO --progress
