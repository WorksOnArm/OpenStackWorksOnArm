# OpenStack Works on ARM Installation Guide

## Overview

Use Terraform to quickly and easily create an OpenStack cloud powered by Armv8 and/or x86 bare metal servers at Packet. Specifically, this deployment showcases how a multi-node cloud can be deployed on Armv8 bare metal.

The deployment defaults to a minimum 4 node OpenStack cloud, consisting of 3 Armv8 nodes and a single x86 node. The x86 node is included to showcase how OpenStack can concurrently manage Arm and x86 virtual workloads atop a heterogenous cloud. 

- The controller and dashboard nodes are configured to run on Armv8 hardware. 
- It is possible to modify the total number of nodes and the type (various sizes of x86 and ARM hardware provided by Packet). 
- By default, the template uses the smallest sized ARM (baremetal_2a) and x86 (baremetal_0) hardware available.

If you require support, please email [help@packet.net](mailto:help@packet.net), visit the Packet IRC channel (#packethost on freenode), subscribe to the [Packet Community Slack channel](https://slack.packet.net) or post an issue within this repository.

Contributions are welcome to help extend this work!

## Cloud Abilities

The default deployment supports both ARM and x86 based virtual workloads across multiple compute nodes. Inter-node communication is setup allowing virtual machines within the same overlay network but on different compute nodes to communicate with each other across underlying VXLAN networks. This is a transparent capability of OpenStack. Management and inter-node traffic travers the private Packet project network (10 subnet). Public OpenStack services are available via the public IP addresses assigned by Packet. DNS is not setup as part of this deployment so use IP addresses to access the services. The backend private IP addresses are mapped automatically into the node hostfiles via the deployment process.

The virtual machine images are deployed with enabled usernames and passwords allowing console login. For more details please see "userdata.txt", the cloud-init file that is used for the CentOS, Fedora, and Ubuntu virtual machines. The Cirros default login information is displayed on the console when logging in. The controller and compute nodes are configured with VNC console access for all the x86 machines. Console access is via the Horizon GUI dashboard. Since the ARM virtual machines do not support VNC console access, novaconsole has been made available on the controller via CLI.

By default, upstream connectivity from inside the cloud (virtual machines/networks) to the Internet is not enabled. Connectivity within internal virtual networks is enabled. The sample workload has SSH (TCP-22) and ICMP traffic enabled via security groups.

## Prerequisites

### Packet Project ID & API Key

This deployment requires a Packet account for the provisioned bare metal. You'll need your "Packet Project ID" and your "Packet API Key" to proceed. You can use an existing project or create a new project for the deployment.

We recommend setting the Packet API Token and Project ID as environment variables since this prevents tokens from being included in source code files. These values can also be stored within a variables file later if using environment variables isn't desired.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

#### Where is my Packet Project ID?

You can find your Project ID under the 'Manage' section in the Packet Portal. They are listed underneath each project in the listing. You can also find the project ID on the project 'Settings' tab, which also features a very handy "copy to clipboard" piece of functionality, for the clicky among us.

#### How can I create a Packet API Key? 

You will find your API Key on the left side of the portal. If you have existing keys you will find them listed on that page. If you haven't created one yet, you can click here:

https://app.packet.net/portal#/api-keys/new

### Terraform

These instructions use Terraform from Hashicorp to drive the deployment. If you don't have Terraform installed already, you can download and install Terraform using the instructions on the link below:
https://www.terraform.io/downloads.html

## Deployment Prep

Download the OpenStackWorksOnARM manifests from GitHub into a local directory.

```bash
git clone https://github.com/WorksOnArm/OpenStackWorksOnArm
cd OpenStackWorksOnArm
```

From that directory, generate an ssh keypair or copy an existing public/private keypair (packet-key and packet-key.pub).

```bash
ssh-keygen -N "" -t rsa -f ./packet-key
```

Download the Terraform providers required:
```bash
terraform init
```

## Defaults

There are a number of defaults that can be modified as desired. Any deviations from the defaults can be set in terraform.tfvars. No modifications to defaults are required except for the Packet Project ID and API Token if not set as environment variables.

Copy over the sample terraform settings:
```bash
cp sample.terraform.tfvars terraform.tfvars
``` 

If the Packet API Token and Project ID were not saved as environment variables then they'll need to be stored in the terraform.tfvars.

### Cloud Sizing Defaults


| Name        | Bare Metal Type | Software               | Default Count | Minimum Count | 
| :---------- | :-------------- | :----------------------| -------------:| -------------:|
| Controller  | baremetal_2a    | Keystone, Glance, Nova | 1             | 1             |
| Dashboard   | baremetal_2a    | Horizon                | 1             | 0 or more     |
| Compute ARM | baremetal_2a    | Neutron, Nova          | 1             | 0 or more     |
| Compute x86 | baremetal_0     | Neutron                | 1             | 0 or more     |


In terraform.tfvars, the type of all these nodes can be changed. The size of the cloud can also be grown by increasing the count of ARM and x86 compute nodes above the default count of 1. A count of 0 of any compute node type (ARM or x86) will render the cloud unable to provision virtual machines of said type. While this deployment will cluster and support multiple compute nodes, it does not support multiple controller or dashboard nodes.

## Deployment

Start the deployment:
```bash
terraform apply
```

At the conclusion of the deployment, the final settings will be displayed. These values can also be output:

```bash
terraform output
```

Sample output as follows:
```
Compute ARM IPs = [
    157.75.73.186
]
Compute ARM Type = baremetal_2a
Compute x86 IPs = [
    157.75.106.151
]
Compute x86 Type = baremetal_0
Controller SSH = ssh root@157.75.79.194 -i ./packet-key
Controller Type = baremetal_0
Horizon dashboard available at = http://157.75.106.119/horizon/ username/password
```

The OpenStack Horizon dashboard can be pulled up at the URL listed with the username/password provided.
The OpenStack Controller (CLI) can be accessed at the SSH address listed with the key provided.


## Sample Workload

This deployment includes the following additional items in addition atop of the OpenStack installation. This includes a set of virtual machine images (Cirros, CentOS, Fedora, Ubuntu), a virtual network and some running virtual machines. For more information on the deployed workloads, please see:

https://github.com/WorksOnArm/OpenStackWorksOnArm/blob/master/SampleOpenStackWorkload.sh


## Validation
The deploy can be verified via the OpenStack CLI and/or via the OpenStack GUI (Horizon). The CLI commands can be run on the Contoller node (via SSH). The GUI commands are run on a web browser using the URL and credentials output by Terraform. The individual CLI commands and GUI drill down paths are listed below. This validation checks that all the compute nodes are running and the same workload virtual machines images are running.

When running the CLI, the OpenStack credentials need to be setup by reading in the openrc file.

* Setup the OpenStack credentials
```bash
source admin-openrc
```

* Validate that all the OpenStack compute services are running. There will be one nova-compute per bare metal compute node provisioned (ARM or x86).
* Horizon: Admin->System Information->Compute Services
```
root@controller:~# openstack compute service list
+----+------------------+----------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host           | Zone     | Status  | State | Updated At                 |
+----+------------------+----------------+----------+---------+-------+----------------------------+
|  1 | nova-consoleauth | controller     | internal | enabled | up    | 2017-10-16T20:08:45.000000 |
|  2 | nova-scheduler   | controller     | internal | enabled | up    | 2017-10-16T20:08:46.000000 |
|  3 | nova-conductor   | controller     | internal | enabled | up    | 2017-10-16T20:08:47.000000 |
|  6 | nova-compute     | compute-x86-00 | nova     | enabled | up    | 2017-10-16T20:08:42.000000 |
|  7 | nova-compute     | compute-arm-00 | nova     | enabled | up    | 2017-10-16T20:08:50.000000 |
+----+------------------+----------------+----------+---------+-------+----------------------------+
```

* Validate that all the images have been installed
* Horizon: Admin->Compute->Images
```
root@controller:~# openstack image list
+--------------------------------------+-----------------+--------+
| ID                                   | Name            | Status |
+--------------------------------------+-----------------+--------+
| d7252321-01ff-4e2d-bff3-746bf3f3cfe6 | CentOS-7-x86_64 | active |
| fd6f2190-b6f0-433d-b36f-8f20389d83ff | Fedora-26-arm64 | active |
| 4baf4977-98c3-4261-8240-2d57d83d5b1c | cirros-x86_64   | active |
| b16d5474-da5f-449b-ab20-5ad4dfdf6bf6 | xenial-arm64    | active |
+--------------------------------------+-----------------+--------+
```

* Validate that all the ARM compute node has the appropriate number of vCPUs and memory
* Horizon: Admin->Compute->Hypervisors
```
root@controller:~# openstack hypervisor show compute-arm-00 -f table -c service_host -c vcpus -c memory_mb -c running_vms
+--------------+----------------+
| Field        | Value          |
+--------------+----------------+
| memory_mb    | 128873         |
| running_vms  | 2              |
| service_host | compute-arm-00 |
| vcpus        | 96             |
+--------------+----------------+
```


* Validate that all the x86 compute node has the appropriate number of vCPUs and memory
```
root@controller:~# openstack hypervisor show compute-x86-00 -f table -c service_host -c vcpus -c memory_mb -c running_vms
+--------------+----------------+
| Field        | Value          |
+--------------+----------------+
| memory_mb    | 7968           |
| running_vms  | 2              |
| service_host | compute-x86-00 |
| vcpus        | 4              |
+--------------+----------------+
```

* Validate that all the virtual machines are running
* Horizon: Admin->Compute->Instances
```
root@controller:~# openstack server list
+--------------------------------------+--------------+--------+-----------------------------------------------+-----------------+----------+
| ID                                   | Name         | Status | Networks                                      | Image           | Flavor   |
+--------------------------------------+--------------+--------+-----------------------------------------------+-----------------+----------+
| 161c63bc-7a15-4f1a-bed9-727c371ed8ae | fedora-arm64 | ACTIVE | sample-workload=192.168.100.13                | Fedora-26-arm64 | m1.small |
| d5ad6fe5-317c-4e81-ad33-48070970a810 | xenial-arm64 | ACTIVE | sample-workload=192.168.100.11                | xenial-arm64    | m1.small |
| fde4add6-391f-4597-8cf5-0f151f732203 | centos-x86   | ACTIVE | sample-workload=192.168.100.5, 192.168.100.15 | CentOS-7-x86_64 | m1.small |
| 9288f3f3-dd10-4cd5-8bd3-ec0fe1ac3025 | cirros-x86   | ACTIVE | sample-workload=192.168.100.8, 192.168.100.12 | cirros-x86_64   | m1.small |
+--------------------------------------+--------------+--------+-----------------------------------------------+-----------------+----------+
```

## Serial Console Support

Access to the serial console is available via the "novaconsole" application installed from the controller node. The OpenStack CLI can be used to general a URL with a valid token to access the console.

```bash
source admin-openrc
openstack console show url --serial xenial-arm64
```

The provided URL can then be passed to the novaconsole command to pull up the serial console.

```bash
novaconsole --url ws://157.75.79.194:6083/?token=18510769-71ad-4e5a-8348-4218b5613b3d
```

Root logins and cloud account logins (centos/ubuntu) are permited using the password in userdata.txt. The cirros default logins are enabled by default.






