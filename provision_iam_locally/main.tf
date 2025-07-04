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

# Utilisation de la politique AWS AdministratorAccess pour les tests
data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attacher la politique AdministratorAccess aux utilisateurs
resource "aws_iam_user_policy_attachment" "stagiaires" {
  for_each   = aws_iam_user.stagiaires
  user       = each.value.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
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