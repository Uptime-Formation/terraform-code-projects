terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }
  }
}

provider "openstack" {
  auth_url    = var.ovh_auth_url
  domain_name = "Default" # Always default on OVH
  use_octavia = true
}
