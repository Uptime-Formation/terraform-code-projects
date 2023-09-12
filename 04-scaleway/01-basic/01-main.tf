terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}
provider "scaleway" {
  access_key      = var.scaleway_api_access_key
  secret_key      = var.scaleway_api_secret_key
  project_id      = var.scaleway_project_id
  organization_id = var.scaleway_organization_id
  zone            = "fr-par-1"
  region          = "fr-par"
}
resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_server" "my-instance" {
  type  = "PLAY2-PICO"
  image = "ubuntu_focal"
  tags  = ["terraform instance", "my-instance"]
  ip_id = scaleway_instance_ip.public_ip.id
  root_volume {
    size_in_gb = 50
  }
}