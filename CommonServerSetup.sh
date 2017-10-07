# General setup - applies to Controller and Compute

# sanity check - make sure we can reach the controller
ping controller -c 5 -q
if [ $? -ne 0 ] ; then
  echo "controller is unreachable"
  echo "check /etc/hosts and networking and then restart this script"
  read -p "press a key"
  exit -1
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


