# Controller Only Below

# private IP addr (10...)
MY_IP=`hostname -I | xargs -n1 | grep "^10\." | head -1`

apt-get -y install openstack-dashboard

/etc/openstack-dashboard/local_settings.py file and complete the following actions:

Configure the dashboard to use OpenStack services on the controller node:

OPENSTACK_HOST = "controller"
In the Dashboard configuration section, allow your hosts to access Dashboard:

ALLOWED_HOSTS = ['one.example.com', 'two.example.com']

onfigure the memcached session storage service:

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}

OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST


OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True


OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}


OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"


OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"


OPENSTACK_NEUTRON_NETWORK = {
    ...
    'enable_router': False,
    'enable_quotas': False,
    'enable_ipv6': False,
    'enable_distributed_router': False,
    'enable_ha_router': False,
    'enable_lb': False,
    'enable_firewall': False,
    'enable_vpn': False,
    'enable_fip_topology_check': False,
}

TIME_ZONE = "TIME_ZONE"


