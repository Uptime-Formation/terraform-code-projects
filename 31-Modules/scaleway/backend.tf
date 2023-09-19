# Storing terraform state in the cloud
terraform {
  backend "s3" {
    bucket                      =
    key                         = "terraform_module.tfstate"
    region                      =
    endpoint                    =
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}
