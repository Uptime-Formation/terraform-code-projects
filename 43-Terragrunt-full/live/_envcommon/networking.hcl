terraform {
  source = "${dirname(find_in_parent_folders())}/../modules//networking"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env       = local.environment_vars.locals.env
}


inputs = {
}
