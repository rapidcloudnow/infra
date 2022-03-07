variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "region" {
  description = "aws region to deploy"
  type = string
  default = "us-east-1"
}
variable "profile" {
  description = "iam user profile to use"
  type = string
  default = "rcn"
}
variable "codepeline_role_name" {
  description = "name of the pipeline role"
  type = string
}
variable "stack_name" {
  default = "rcn"
  description = "application stack name"
}
variable "app_short_name" {
  description = "application short name,example web,db,etc"
  default = "web"
  type = string
}
variable "codepipeline_artifacts_store" {
  description = "location of artifacts store for codepipeline"
  type = string
  default = "rcn-codepipeline-artifacts"
}
variable "codepipeline_source_bucket" {
  description = "codepipeline source"
  type = string
  default = "rcn-web-source-code"
}
variable "codepipeline_destination_bucket" {
  description = "codepipeline destination bucket"
  type = string
  default = "prod.rapidcloudnow.com"
}
variable "app_artifacts" {
  description = "application artifact, it must be zip format"
  type = string
}