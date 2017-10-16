export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

until openstack flavor list
do
  echo "waiting for OpenStack Neutron (flavor) to come online"
  sleep 5
done

# some default flavors
openstack flavor create --ram 512   --disk 1   --vcpus 1 m1.tiny
openstack flavor create --ram 2048  --disk 20  --vcpus 1 m1.small
openstack flavor create --ram 4096  --disk 40  --vcpus 2 m1.medium
openstack flavor create --ram 8192  --disk 80  --vcpus 4 m1.large
openstack flavor create --ram 16384 --disk 160 --vcpus 8 m1.xlarge
