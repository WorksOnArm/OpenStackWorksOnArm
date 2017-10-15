#OpenStack Works on ARM Installation Guide
You can create an OpenStack cluster on Packet ARM bare metal using Terraform.

The included Terraform templates are configured to run OpenStack on Packet. Depending on the amount of computing power your workload needs, you might have to modify the templates to suit your needs. You can modify the Terraform templates, but  cannot assist in troubleshooting. If you require support, please email help@packet.net or visit the Packet IRC channel (#packethost on freenode).

Prerequisites:
Packet API Key

Packet Project ID

Terraform by Hashicorp

Download and install Terraform using the instructions on the link provided above

Download the OpenStackWorksOnARM manifests from GitHub into a local directory.

```bash
git clone https://github.com/WorksOnArm/OpenStackWorksOnArm
```

From that directory, generate an ssh keypair:

```bash
ssh-keygen -N "" -t rsa -f ./packet-key
```

Download the Terraform providers required:
```bash
terraform init
```

Copy over the sample terraform settings:
```bash
cp sample.terraform.tfvars terraform.tfvars
``` 

Setup the Packet API Token and Project ID as environment variables in terraform.tfvars _or_ set environment variables. We recommend setting environment variables since this prevents tokens from being included in source code files.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

The default cloud consists of:
1 OpenStack ARM Controller (T2A)
1 OpenStack ARM Dashboard  (T2A)
1 OpenStack ARM Compute Node (T2A)
1 OpenStack x86 Compute Node (T0)

In terraform.tfvars, the type of all these nodes can be changed. The size of the cloud can also be grown by increasing the count of ARM and x86 compute nodes by increasing above the default count of 1. 

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

OpenStack Verification via Horizon

### TODO


OpenStack Verification via CLI


### TODO



