variable "upload_files" {
  description = "choose to upload files"
  default = false
  type = bool
}
variable "files_path" {
  description = "directory or path of the files"
  default = null
  type = string
}
variable "region" {
  description = "name of the aws region"
  default = "us-east-1"
  type = string
}
variable "s3_bucket_name" {
  description = "name of the s3 bucket to upload files"
  default = null
  type = string
}
variable "profile" {
  description = "iam user profile to use"
  type = string
  default = "rcn"
}