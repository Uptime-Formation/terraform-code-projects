# users.tf
variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  region     = "eu-west-3"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_iam_user" "stagiaires" {
  for_each = toset(var.user_names)

  name = each.value
  path = "/stagiaires/"

  tags = {
    Team        = "Stagiaire"
    Environment = "Formation"
    ManagedBy   = "Terraform"
  }
}

# Créer des clés d'accès pour les utilisateurs
resource "aws_iam_access_key" "stagiaires" {
  for_each = aws_iam_user.stagiaires
  user     = each.value.name
}

# Politique pour les développeurs
resource "aws_iam_policy" "stagiaires_policy" {
  name        = "DeveloperPolicy"
  description = "Policy for developers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::dev-bucket/*",
          "arn:aws:s3:::dev-bucket"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attacher la politique aux utilisateurs
resource "aws_iam_user_policy_attachment" "stagiaires" {
  for_each   = aws_iam_user.stagiaires
  user       = each.value.name
  policy_arn = aws_iam_policy.stagiaires_policy.arn
}

# Get the first user name
locals {
  first_user = length(var.user_names) > 0 ? var.user_names[0] : ""
  first_user_access_key = local.first_user != "" ? aws_iam_access_key.stagiaires[local.first_user] : null
}

# Manage AWS CLI config file
resource "local_file" "aws_config" {
  count = local.first_user != "" ? 1 : 0
  
  filename = pathexpand("~/.aws/config")
  file_permission = "0600"
  
  content = <<-EOT
[default]
region = eu-west-3

[profile ${local.first_user}]
region = eu-west-3
output = json
EOT
}

# Manage AWS CLI credentials file
resource "local_file" "aws_credentials" {
  count = local.first_user != "" ? 1 : 0
  
  filename = pathexpand("~/.aws/credentials")
  file_permission = "0600"
  
  content = <<-EOT
[default]
aws_access_key_id = ${var.aws_access_key}
aws_secret_access_key = ${var.aws_secret_key}

[${local.first_user}]
aws_access_key_id = ${local.first_user_access_key.id}
aws_secret_access_key = ${local.first_user_access_key.secret}
EOT
}

# Outputs pour récupérer les informations
output "user_access_keys" {
  value = {
    for user, key in aws_iam_access_key.stagiaires : user => {
      access_key = key.id
      secret_key = key.secret
    }
  }
  sensitive = true
}

output "first_user_profile" {
  value = local.first_user != "" ? {
    profile_name = local.first_user
    access_key = local.first_user_access_key.id
  } : null
  sensitive = true
  description = "AWS CLI profile created for the first user"
}