
variable "packet_api_key" {
  description = "Your packet API key"
}

variable "packet_project_id" {
  description = "Packet Project ID"
}

variable "packet_facility" {
  description = "Packet facility: US East(ewr1), US West(sjc1), or EU(ams1). Default: sjc1"
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

variable "packet_compute_type" {
  description = "Instance type of OpenStack compute"
  default = "baremetal_0"
}

variable "openstack_compute_count" {
  description = "Number of OpenStack Compute nodes to deploy"
  default = "1"
}

variable "cloud_ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default = "./packet-key.pub"
}

variable "cloud_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "./packet-key"
}
