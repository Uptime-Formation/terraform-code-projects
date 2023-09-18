variable ovh_auth_url {
  description = "Authentification URL"
  type        = string
  default     = "https://auth.cloud.ovh.net/v3/"
}


# OpenStack Variables
# Documentation: https://help.ovhcloud.com/csm/fr-public-cloud-compute-set-openstack-environment-variables?
variable "openstack_user_name" {
  description = "OpenStack Auth: the Horizon user name (ex: user-M8jaFSTFBQwr)"
  type        = string
}
variable "openstack_user_password" {
  description = "OpenStack Auth: the Horizon user password (ex: nevCfcwn9qaDxBP5uYQpu8azrqEYJprJ )"
  type        = string
}
variable "openstack_tenant_name" {
  description = "OpenStack Auth: the project name (ex: 2021829215909488)"
  type        = string
}
variable "openstack_project_id" {
  description = "OpenStack Auth: the Project name (ex: ecd2506ade74e9415ea3aea4674c65c6)"
  type        = string
}
variable "openstack_region" {
  description = "OpenStack Region you wish to use"
  type        = string
  default     = "BHS5"
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
