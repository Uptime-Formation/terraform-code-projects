variable "vrack_bastion_network_name" {
  description = "Name of the network"
  default     = "certification_bastion_net"
}
variable "vrack_bastion_vlan" {
  description = "ID of the VLAN to use"
  default     = "169"
}
variable "vrack_bastion_range" {
  description = "Place d'adressage IP du sous réseau"
  default     = "192.168.169.0/24"
}
