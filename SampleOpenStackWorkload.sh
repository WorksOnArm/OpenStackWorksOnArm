#
#
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack keypair create default > default.pem

#
SEC_GROUP=`openstack security group create ssh-icmp -f value -c id`
openstack security group rule create --protocol icmp --ingress $SEC_GROUP
openstack security group rule create --dst-port 22 --protocol tcp --ingress $SEC_GROUP

#
# create an network
#
NETWORK_ID=`openstack network create sample-workload -f value -c id`
INTERNAL_SUBNET="192.168.100.0/24"

SUBNET_ID=`openstack subnet create              \
        --network ${NETWORK_ID}                   \
        --subnet-range $INTERNAL_SUBNET         \
        $INTERNAL_SUBNET -f value -c id`

#
# create a cirros x86 machine
#
openstack server create \
	--flavor m1.tiny \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Cirros-x86_64 \
	--key-name default \
	Cirros-x86

#
# create x86 machines with password based logins enabled
#
openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image CentOS-7-x86_64 \
	--key-name default \
	--user-data userdata.txt \
	Centos-x86

#
# create ARM machines with password based logins enabled
#
openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Artful-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Artful-arm64

openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Trusty-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Trusty-arm64

openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Bionic-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Bionic-arm64

openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
  --image CentOS-7-arm64 \
  --key-name default \
  --user-data userdata.txt \
  Centos-arm64

openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Xenial-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Xenial-arm64

openstack server create \
	--flavor m1.small \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Fedora-26-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Fedora-arm64

openstack server create \
	--flavor m1.tiny \
	--network ${NETWORK_ID} \
	--security-group ${SEC_GROUP} \
	--image Cirros-arm64 \
	--key-name default \
	--user-data userdata.txt \
	Cirros-arm64
