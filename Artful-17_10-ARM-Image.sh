export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

# Download ARM images and upload into OpenStack (Glance)

IMG_URL=https://cloud-images.ubuntu.com/releases/17.10/release/ubuntu-17.10-server-cloudimg-arm64.tar.gz
IMG_NAME=Artful-arm64
OS_DISTRO=ubuntu
wget --quiet $IMG_URL
tar xfvz ubuntu-17.10-server-cloudimg-arm64.tar.gz artful-server-cloudimg-arm64.img
openstack image create \
	--disk-format qcow2 --container-format bare \
	--file artful-server-cloudimg-arm64.img \
	--property hw_firmware_type=uefi \
	--public \
	$IMG_NAME
rm artful-server-cloudimg-arm64.img
rm ubuntu-17.10-server-cloudimg-arm64.tar.gz
