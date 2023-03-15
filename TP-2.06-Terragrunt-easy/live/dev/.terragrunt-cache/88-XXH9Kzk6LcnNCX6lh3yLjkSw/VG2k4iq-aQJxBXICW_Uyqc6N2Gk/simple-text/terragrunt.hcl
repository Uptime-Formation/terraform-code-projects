terraform {
  source = "${dirname(find_in_parent_folders())}/../modules//simple-text"
}

locals {
  text = <<-EOT
    The story so far:
    In the beginning the Universe was created.
    This has made a lot of people very angry and been widely regarded as a bad move.
  EOT
  destination = "/tmp/tf-terragrunt-demo-dev.txt"
}

inputs = {
  text = local.text
  destination = local.destination
}
