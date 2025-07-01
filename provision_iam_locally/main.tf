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

# Politique pour les stagiaires
resource "aws_iam_policy" "stagiaires_policy" {
  name        = "StagiairesPolicy"
  description = "Policy for stagiaires with S3, EC2, and AMI permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 Permissions
      {
        Sid    = "S3BucketManagement"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging"
        ]
        Resource = "arn:aws:s3:::*"
      },
      {
        Sid    = "S3ObjectManagement"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:DeleteObjectVersion"
        ]
        Resource = "arn:aws:s3:::*/*"
      },
      {
        Sid    = "S3ListAllBuckets"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy"
        ]
        Resource = "*"
      },
      # EC2 Permissions
      {
        Sid    = "EC2InstanceManagement"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceCreditSpecifications",
          "ec2:ModifyInstanceCreditSpecification",
          "ec2:ModifyInstanceAttribute",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      },
      {
        Sid    = "EC2SecurityGroupManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress"
        ]
        Resource = "*"
      },
      {
        Sid    = "EC2KeyPairManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateKeyPair",
          "ec2:DeleteKeyPair",
          "ec2:DescribeKeyPairs",
          "ec2:ImportKeyPair"
        ]
        Resource = "*"
      },
      # AMI Permissions
      {
        Sid    = "AMIAccess"
        Effect = "Allow"
        Action = [
          "ec2:DescribeImages",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSnapshotAttribute"
        ]
        Resource = "*"
      },
      # VPC and Networking (needed for EC2)
      {
        Sid    = "VPCNetworking"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeRouteTables",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
          "ec2:DescribeAddresses"
        ]
        Resource = "*"
      },
      # EBS Volumes (needed for EC2)
      {
        Sid    = "EBSVolumeManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolumeAttribute",
          "ec2:DescribeVolumeAttribute",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
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
  first_user            = length(var.user_names) > 0 ? var.user_names[0] : ""
  first_user_access_key = local.first_user != "" ? aws_iam_access_key.stagiaires[local.first_user] : null
}

# Manage AWS CLI profile using AWS CLI commands
resource "null_resource" "aws_cli_profile" {
  count = local.first_user != "" && var.manage_aws_cli_config ? 1 : 0

  depends_on = [aws_iam_access_key.stagiaires]

  triggers = {
    profile_name = local.first_user
    access_key   = local.first_user_access_key.id
  }

  # Create or update the AWS CLI profile
  provisioner "local-exec" {
    command = <<-EOT
      # Check if AWS CLI is installed
      if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Please install it to manage profiles."
        exit 1
      fi

      # Configure the profile
      aws configure set aws_access_key_id ${local.first_user_access_key.id} --profile ${local.first_user}
      aws configure set aws_secret_access_key ${local.first_user_access_key.secret} --profile ${local.first_user}
      aws configure set region ${var.aws_region} --profile ${local.first_user}
      aws configure set output ${var.aws_cli_output_format} --profile ${local.first_user}
      
      echo "AWS CLI profile '${local.first_user}' has been configured successfully."
    EOT
  }

  # Remove the profile on destroy
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Check if AWS CLI is installed
      if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Skipping profile removal."
        exit 0
      fi

      # Remove the profile entries
      profile_name="${self.triggers.profile_name}"
      
      # Remove from credentials file
      if [ -f ~/.aws/credentials ]; then
        sed -i.bak "/^\[$${profile_name}\]/,/^\[/{ /^\[$${profile_name}\]/d; /^\[/!d; }" ~/.aws/credentials
      fi
      
      # Remove from config file
      if [ -f ~/.aws/config ]; then
        sed -i.bak "/^\[profile $${profile_name}\]/,/^\[/{ /^\[profile $${profile_name}\]/d; /^\[/!d; }" ~/.aws/config
      fi
      
      echo "AWS CLI profile '$${profile_name}' has been removed."
    EOT
  }
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
    profile_name  = local.first_user
    access_key    = local.first_user_access_key.id
    usage_example = "aws s3 ls --profile ${local.first_user}"
  } : null
  sensitive   = true
  description = "AWS CLI profile created for the first user"
}