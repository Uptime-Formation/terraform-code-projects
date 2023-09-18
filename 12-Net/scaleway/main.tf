terraform {
  required_version = ">= 1.0.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
    }
  }
}


provider "scaleway" {
    region = "fr-par"
}
