terraform {
  required_version = ">= 0.14.0"
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.13.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }
  }
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

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_app_key
  application_secret = var.ovh_app_secret
  consumer_key       = var.ovh_consumer_key
}

