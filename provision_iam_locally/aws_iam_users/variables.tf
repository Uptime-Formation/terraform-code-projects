
variable "user_names" {
  description = "List of the user names to create in AWS IAM"
  type        = list(string)
  sensitive   = false
  default     = ["laptop"]
}