terraform {
  source = "../../modules//autoscaling"
}
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

}

inputs = {
  namespace = local.namespace
}
