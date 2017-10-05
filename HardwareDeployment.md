


## Bare Metal Deployment

Two ARM based hosts are deployed via the Packet GUI. One will be used as the OpenStack controller node and the second as an OpenStack compute node.

Hostname: controller
Type: 2A2
OS: Ubuntu 16.04 LTS
Options: Subnet Size: /29

Hostname: compute
Type: 2A2
OS: Ubuntu 16.04 LTS
Options: none required


Assigning a Subnet Size of /29 to the controller provides 8 public IP addresses to the cloud. A /30 is the smallest that will allow external connectivity from within the cloud to the Internet (via NAT) but would not allow for any assignable public addresses to the virtual instances. A /29 is the smallest suitable size if you wish to publish external addressible services (i.e. a web server). Obviously, large address spaces will also work (/28, /27, etc).


## Host File

Update the host files (/etc/hosts) on each of the compute and controller adding in the private (10.) IP address. These IP address can be obtained from the Packet App or with the command "hostname -I".
```bash
# OpenStack hosts
10.64.67.5      compute
10.64.67.1      controller
```

## Validate Internal Network Connectivity

Ping the compute and controller nodes from each other to validate that the hostnames and networking is running correctly.

```bash
ping compute
ping controller
```
