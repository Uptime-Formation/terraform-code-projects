variable ovh_auth_url {
  description = "Authentification URL"
  type        = string
  default     = "https://auth.cloud.ovh.net/v3/"
}


variable "openstack_region" {
  description = "OpenStack Region you wish to use"
  type        = string
}
variable "ovh_ssh_key_path" {
  description = "Location of your ssh key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ovh_ssh_key_name" {
  description = "Name of your ssh key"
  type        = string
  default     = "certification key"
}
