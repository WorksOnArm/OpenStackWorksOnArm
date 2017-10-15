# OpenStack Works on ARM Installation Guide

## Overview

You can create an OpenStack cloud powered by Packet ARM bare metal using Terraform quickly and easily using these instructions. This deployment showcases how a multi-node cloud can be deployed across ARM powered bare metal.

This deployment defaults to a minimum 4 node OpenStack cloud consisting of 3 ARM nodes and a single x86 node. The x86 node is included to showcase how OpenStack can concurrently manage ARM and x86 virtual workloads atop a heterogenous cloud. The controller and dashboard nodes are configured to run on ARM hardware. It is possible to modify the total number of nodes and the type (various sizes of x86 and ARM hardware provided by Packet). By default, the template uses the smallest sized ARM (baremetal_2a) and x86 (baremetal_0) hardware available.

If you require support, please email help@packet.net, visit the Packet IRC channel (#packethost on freenode), or post an issue within this GitHub.

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

The default cloud consists of:

| Name        | Bare Metal Type | Software               | Default Count | Count 
| ----------- | --------------- |----------------------- |---------------------
| Controller  | baremetal_2a    | Keystone, Glance, Nova | 1             | 1
| Dashboard   | baremetal_2a    | Horizon                | 1             | 0 or more
| Compute ARM | baremetal_2a    | Neutron, Nova          | 1             | 0 or more
| Compute x86 | baremetal_0     | Neutron                | 1             | 0 or more


In terraform.tfvars, the type of all these nodes can be changed. The size of the cloud can also be grown by increasing the count of ARM and x86 compute nodes by increasing above the default count of 1. 

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


OpenStack Defaults

This deployment includes the following additional items in addition atop of the OpenStack installation. This includes a set of virtual machine images (Cirros, CentOS, Fedora, Ubuntu), a virtual network and some running virtual machines.


## Validation
OpenStack Verification via Horizon

### TODO


OpenStack Verification via CLI


### TODO



