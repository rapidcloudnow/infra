module "web" {
  source = "../modules/s3hosting"
  tags = var.tags
  env = terraform.workspace
  subdomain_name = var.subdomain_name
  domain_name = var.domain_name
}