variable "machine_count" {
  description = "Number of virtual machines in private network"
  default = 1
}
variable "machine_flavor" {
  description = "Type of server to provision"
  default = "PLAY2-PICO"
}
