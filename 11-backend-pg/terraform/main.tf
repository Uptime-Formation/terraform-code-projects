terraform { 
  backend "pg" {
    conn_str = "postgres://terraform:somepassword@127.0.0.1/terraform"
    schema_name   = "myapp"
  }
  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "literature" {
  filename = "adam-douglas.txt"
  content     = <<-EOT
    The story so far:
    In the beginning the Universe was created.
    This has made a lot of people very angry and been widely regarded as a bad move.
  EOT
}
