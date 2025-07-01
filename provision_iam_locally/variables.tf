
variable "user_names" {
  description = "List of the user names to create in AWS IAM"
  type        = list(string)
  sensitive   = false
  default     = ["laptop"]
}

variable "aws_region" {
  description = "AWS region for the CLI configuration"
  type        = string
  default     = "eu-west-3"
}

variable "aws_cli_output_format" {
  description = "Output format for AWS CLI (json, yaml, yaml-stream, text, table)"
  type        = string
  default     = "json"
}

variable "manage_aws_cli_config" {
  description = "Whether to manage AWS CLI configuration files"
  type        = bool
  default     = true
}