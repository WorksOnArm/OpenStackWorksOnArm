# OpenStackWorksOnArm


## Deploy Physical Hardware

* Deploy two ARM powered Packet hosts
* Provision a pool of IP addresses from Packet
* Setup /etc/hosts


## Install OpenStack

### Controller

```bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ControllerKeystone.sh | bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ControllerGlance.sh | bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ControllerNova.sh | bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ControllerNeutron.sh | bash
```

### Compute

```bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ComputeNova.sh | bash
curl https://raw.githubusercontent.com/WorksOnArm/OpenStackWorksOnArm/master/ComputeNeutron.sh | bash
```

## Configure OpenStack

* Setup physical network into OpenStack
* Setup virtual networking
* Setup ARM virtual machine images

## Startup Application Workloads
