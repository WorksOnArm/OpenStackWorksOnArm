#
# Prereq Components for both Controller and Compute nodes
#

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

apt -y install software-properties-common
add-apt-repository -y cloud-archive:pike
apt -y update
apt -y install python-openstackclient


# easy modification of .ini configuration files
apt-get -y install crudini



