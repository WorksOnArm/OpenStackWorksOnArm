# General setup - applies to Controller and Compute

# sanity check - make sure we can reach the controller
ping controller -c 5 -q
if [ $? -ne 0 ] ; then
  echo "controller is unreachable via ping"
  echo "check /etc/hosts and networking"
fi

# private IP addr (10...)
MY_IP=`hostname -I | xargs -n1 | grep "^10\." | head -1`


# general system updates
apt-get -y update

# non-interactively set a timezone so we're not interactively prompted
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# OpenStack needs precise time services
apt-get -y install chrony
service chrony restart

apt-get -y install software-properties-common
add-apt-repository -y cloud-archive:pike
apt-get -y update
apt-get -y install python-openstackclient


# easy modification of .ini configuration files
apt-get -y install crudini


  
cat >> admin-openrc << EOF
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF

cat >> demo-openrc << EOF
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
