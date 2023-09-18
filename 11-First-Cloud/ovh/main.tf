terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }
  }
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

provider "openstack" {
  auth_url    = var.ovh_auth_url
  domain_name = "Default" # Always default on OVH
  user_name   = var.openstack_user_name
  tenant_name = var.openstack_tenant_name
  password    = var.openstack_user_password
  region      = var.openstack_region
  use_octavia = true
}
resource "openstack_compute_keypair_v2" "certification_key" {
  name       = var.ovh_ssh_key_name
  public_key = file(var.ovh_ssh_key_path) # Path to your previously generated SSH key
}
data "openstack_images_image_v2" "some_distro" {
  name = "Ubuntu 23.04"
}

resource "openstack_compute_instance_v2" "certification_instance" {
  name        = "terraform_instance"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.name
  network {
    name = "Ext-Net"
  }
}

output "instance_addresses" {
  value = openstack_compute_instance_v2.certification_instance.access_ip_v4
}
