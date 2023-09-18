variable "vrack_network_name" {
  description = "Name of the network"
  default     = "certification_net"
}
variable "vrack_vlan" {
  description = "ID of the VLAN to use"
  default     = "168"
}
variable "vrack_range" {
  description = "Place d'adressage IP du sous réseau"
  default     = "192.168.168.0/24"
}
variable "vrack_range_gateway" {
  description = "Place d'adressage IP du sous réseau"
  default     = "192.168.168.1"
}
variable "vrack_range_start" {
  description = "Première IP du sous réseau"
  default     = "192.168.168.100"
}
variable "vrack_range_end" {
  description = "Dernière IP du sous réseau"
  default     = "192.168.168.200"
}
