



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
