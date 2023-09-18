terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.2"
    }
  }
  required_version = ">=  1.0"
}

resource "scaleway_object_bucket" "terraform-bucket" {
  name = var.bucket_name
}

output "bucket" {
  value = scaleway_object_bucket.terraform-bucket
}