#
#
# associate elastic IP subnet with the controller node via the Packet Web GUI
#
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

#"147.75.38.128/25"
PROVIDER_CIDR=$1

if [ -z $PROVIDER_CIDR ]; then
  echo "usage: $0 PROVIDER_CIDR"
  exit -1
fi

PROVIDER_ID=`openstack network create --share \
		--provider-physical-network provider \
		--provider-network-type flat provider \
		--external \
        	-f value -c id`

SUBNET_ID=`openstack subnet create              \
        --network ${PROVIDER_ID}                   \
        --subnet-range $PROVIDER_CIDR         \
        $PROVIDER_CIDR -f value -c id`

# assign this gateway to all routers
for ROUTER_ID in `openstack router list -f value -c ID`
do
openstack router set --external-gateway $PROVIDER_ID $ROUTER_ID
done

# assign this subnet to the provider bridge
PROVIDER_CIDR_MSV="$(echo $PROVIDER_CIDR | cut -d/ -f1 | cut -d. -f1-3)"
#echo $PROVIDER_CIDR_MSV
PROVIDER_CIDR_LSV="$(echo $PROVIDER_CIDR | cut -d/ -f1 | cut -d. -f4)"
#echo $PROVIDER_CIDR_LSV
PROVIDER_CIDR_LSV=$(( $PROVIDER_CIDR_LSV + 1 ))
#echo $PROVIDER_CIDR_LSV
PROVIDER_CIDR_SIZE="$(echo $PROVIDER_CIDR | cut -d/ -f2)"
#echo $PROVIDER_CIDR_SIZE

PROVIDER_IP=${PROVIDER_CIDR_MSV}.${PROVIDER_CIDR_LSV}/${PROVIDER_CIDR_SIZE}
PROVIDER_BRIDGE=`brctl show | grep bond0 | cut -f1`
ip a a ${PROVIDER_CIDR_IP} dev $PROVIDER_BRIDGE
