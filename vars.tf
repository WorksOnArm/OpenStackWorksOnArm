
variable "packet_api_key" {
  description = "Your packet API key"
}

variable "packet_project_id" {
  description = "Packet Project ID"
}

variable "packet_facility" {
  description = "Packet facility: US East(ewr1), US West(sjc1), Tokyo (nrt1) or EU(ams1). Default: sjc1"
  default = "sjc1"
}

variable "packet_controller_type" {
  description = "Instance type of OpenStack controller"
  default = "baremetal_0"
}

variable "packet_dashboard_type" {
  description = "Instance type of OpenStack dashboard"
  default = "baremetal_0"
}

variable "packet_compute-x86_type" {
  description = "Instance type of OpenStack x86 compute nodes"
  default = "baremetal_0"
}

variable "openstack_compute-x86_count" {
  description = "Number of OpenStack x86 compute nodes to deploy"
  default = "2"
}

variable "packet_compute-arm_type" {
  description = "Instance type of OpenStack ARM compute nodes"
  default = "baremetal_2a"
}

variable "openstack_compute-arm_count" {
  description = "Number of OpenStack ARM compute nodes to deploy"
  default = "2"
}

variable "cloud_ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default = "./packet-key.pub"
}

variable "cloud_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "./packet-key"
}
