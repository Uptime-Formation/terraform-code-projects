terraform { 
  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "literature" {
  filename    = var.destination
  content     = var.text
}
