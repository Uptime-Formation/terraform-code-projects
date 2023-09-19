locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region           = local.region_vars.locals.region
  env              = local.environment_vars.locals.env
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}


remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}mon-premier-deploiement-terragrunt-${local.env}-${local.region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
)
