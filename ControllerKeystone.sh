# Controller Only Below

apt -y install mariadb-server python-pymysql

# private IP addr (10...)
MY_IP=`hostname -I | cut -d ' ' -f 2`

cat >> /etc/mysql/mariadb.conf.d/99-openstack.cnf << EOF
[mysqld]
bind-address = ${MY_IP}

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF

service mysql restart

# harden MySQL
# mysql_secure_installation

mysql --batch -e "\
CREATE DATABASE keystone; \
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS'; \
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS'; \
FLUSH PRIVILEGES"

# Keystone Packages
apt-get -y install keystone  apache2 libapache2-mod-wsgi

crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
crudini --set /etc/keystone/keystone.conf token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

echo "ServerName controller" >> /etc/apache2/apache2.conf
service apache2 restart

  
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


openstack project create --domain default \
  --description "Service Project" service
  
openstack project create --domain default \
  --description "Demo Project" demo
  
openstack user create --domain default \
  --password-prompt demo
  
openstack role create user

openstack role add --project demo --user demo user

# small 
. admin-openrc
openstack token issue

if [ $? -ne 0 ]; then
  echo "issues generating a keystone token"
else
  echo "successfully issued a keystone token"
fi




