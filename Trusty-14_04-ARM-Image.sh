export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

# Download ARM images and upload into OpenStack (Glance)

IMG_URL=https://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-arm64.tar.gz
IMG_NAME=Trusty-arm64
OS_DISTRO=ubuntu
wget --quiet $IMG_URL
tar xfvz ubuntu-14.04-server-cloudimg-arm64.tar.gz trusty-server-cloudimg-arm64.img
openstack image create \
	--disk-format qcow2 --container-format bare \
	--file trusty-server-cloudimg-arm64.img \
	--property hw_firmware_type=uefi \
	--public \
	$IMG_NAME
rm trusty-server-cloudimg-arm64.img
rm ubuntu-14.04-server-cloudimg-arm64.tar.gz
