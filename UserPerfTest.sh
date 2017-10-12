#/bin/bash

export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

errors=0
out_max=5
concurrent_connections=20

for j in `seq 1 5`
do

  for i in `seq 1 $concurrent_connections`
  do
    openstack user create --password secret user$i > /dev/null &
    if [ $? -ne 0 ]; then
      ((errors++))
    fi
  done
  wait
  
  for i in `seq 1 $concurrent_connections`
  do
    openstack user delete user$i > /dev/null &
    if [ $? -ne 0 ]; then
      ((errors++))
  fi
  done
  wait

done

echo "Test name: " $0
echo "Total execs: " $((out_max*concurrent_connections))
echo "Total errors: " $errors
