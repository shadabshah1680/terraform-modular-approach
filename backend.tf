terraform {
  backend "s3" {
    bucket               = "shadab-terraform-backend"
    region               = "us-west-2"
    key                  = "backend.tfstate"
    workspace_key_prefix = "infra"
    dynamodb_table       = "shadab-terraform-backend"
  }
}
