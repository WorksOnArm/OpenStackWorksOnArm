

$ mysql -u root -p
Create the glance database:

mysql> CREATE DATABASE glance;
Grant proper access to the glance database:

mysql> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'GLANCE_DBPASS';
mysql> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'GLANCE_DBPASS';
  
  . admin-openrc
  
  openstack user create --domain default --password XXXX glance
  openstack role add --project service --user glance admin
  
  openstack service create --name glance \
  --description "OpenStack Image" image
  
  openstack endpoint create --region RegionOne \
  image public http://controller:9292
  
  openstack endpoint create --region RegionOne \
  image internal http://controller:9292
  
  openstack endpoint create --region RegionOne \
  image admin http://controller:9292
  
  apt install glance
  
  /etc/glance/glance-api.conf
  
  [database]
...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
...
flavor = keystone



[glance_store]
...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

/etc/glance/glance-registry.conf

[database]
...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
...
flavor = keystone


su -s /bin/sh -c "glance-manage db_sync" glance



## TODO - restart services
