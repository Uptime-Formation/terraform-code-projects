# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "mon-premier-deploiement-terragrunt-dev-us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    key            = "dev/networking/terraform.tfstate"
    region         = "us-west-2"
  }
}
