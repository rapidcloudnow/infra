variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "region" {
  description = "aws region to deploy"
  type = string
  default = "us-east-2"
}
variable "profile" {
  description = "iam user profile to use"
  type = string
  default = "rcn"
}
variable "domain_name" {
  description = "domain name of this site"
  default = "example.com"
  type = string
}
variable "subdomain_name" {
  description = "subdomain name of this site"
  type = string
  default = "www"
}
variable "index_document_name" {
  description = "name of the index document"
  default = "index.html"
  type = string
}