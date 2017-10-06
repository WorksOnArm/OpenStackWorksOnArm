# Controller Only Below

# private IP addr (10...)
MY_IP=`hostname -I | xargs -n1 | grep "^10\." | head -1`


## nova
mysql --batch -e "\
CREATE DATABASE neutron; \
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY 'NEUTRON_DBPASS'; \
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY 'NEUTRON_DBPASS'; \
FLUSH PRIVILEGES;"

. admin-openrc

openstack user create --domain default --password NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron \
  --description "OpenStack Networking" network
openstack endpoint create --region RegionOne \
  network public http://controller:9696
  openstack endpoint create --region RegionOne \
  network internal http://controller:9696
  openstack endpoint create --region RegionOne \
  network admin http://controller:9696
  
  
# setup provider networking

apt -y install neutron-server neutron-plugin-ml2 \
  neutron-linuxbridge-agent neutron-dhcp-agent \
  neutron-metadata-agent

/etc/neutron/neutron.conf file and complete the following actions:

In the [database] section, configure database access:

[database]
# ...
connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron

[DEFAULT]
# ...
core_plugin = ml2
service_plugins =

[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller

[DEFAULT]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = NEUTRON_PASS

[DEFAULT]
# ...
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[nova]
# ...
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = NOVA_PASS

/etc/neutron/plugins/ml2/ml2_conf.ini file and complete the following actions:

In the [ml2] section, enable flat and VLAN networks:

[ml2]
# ...
type_drivers = flat,vlan

[ml2]
# ...
tenant_network_types =

[ml2]
# ...
mechanism_drivers = linuxbridge

[ml2]
# ...
extension_drivers = port_security

[ml2_type_flat]
# ...
flat_networks = provider

[securitygroup]
# ...
enable_ipset = true

/etc/neutron/plugins/ml2/linuxbridge_agent.ini file and complete the following actions:

In the [linux_bridge] section, map the provider virtual network to the provider physical network interface:

[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME

[vxlan]
enable_vxlan = false

[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

/etc/neutron/dhcp_agent.ini file and complete the following actions:

In the [DEFAULT] section, configure the Linux bridge interface driver, Dnsmasq DHCP driver, and enable isolated metadata so instances on provider networks can access metadata over the network:

[DEFAULT]
# ...
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true


# end of provider networking

  
  /etc/neutron/metadata_agent.ini
  [DEFAULT]
# ...
nova_metadata_ip = controller
metadata_proxy_shared_secret = METADATA_SECRET

/etc/nova/nova.conf
[neutron]
# ...
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS
service_metadata_proxy = true
metadata_proxy_shared_secret = METADATA_SECRET

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
  
  service nova-api restart
  
  service neutron-server restart
# service neutron-linuxbridge-agent restart
# service neutron-dhcp-agent restart
# service neutron-metadata-agent restart

# service neutron-l3-agent restart


