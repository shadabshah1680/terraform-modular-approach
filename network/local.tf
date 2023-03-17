locals {
  config  = yamldecode(file("config/${terraform.workspace}/configfile.yml"))
}