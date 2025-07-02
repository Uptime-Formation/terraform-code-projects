# users.tf
# variable "aws_access_key" {}
# variable "aws_secret_key" {}

provider "aws" {
  region  = var.aws_region
  profile = "terraform-admin"
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
  name        = "StagiairesPolicy"
  description = "Policy for stagiaires with S3, EC2, and AMI permissions"

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
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:AttachVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:TerminateInstances",
          "ec2:CreateImage",
          "ec2:RegisterImage",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ec2:DescribeTags",
          "ec2:GetPasswordData",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeKeyPairs",
          "ec2:CreateKeyPair",
          "ec2:DeleteKeyPair",
          "ec2:ImportKeyPair"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "arn:aws:iam::*:role/packer*"
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