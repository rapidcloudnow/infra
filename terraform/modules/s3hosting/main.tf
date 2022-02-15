
#create s3 bucket to host our site
resource "aws_s3_bucket" "main" {
  bucket = join(".",[var.subdomain_name,var.domain_name])
  website {
    index_document = var.index_document_name
  }
  logging {
    target_bucket = aws_s3_bucket.this.id
  }
  versioning {
    enabled = true
  }
  tags = var.tags
}
#create s3 bucket to host website logs
resource "aws_s3_bucket" "this" {
  bucket = join("-",[var.domain_name,"logs"])
  acl = "log-delivery-write"
  tags = var.tags
}

#create redirect to redirect http to https
resource "aws_s3_bucket" "redirect-http-https" {
  bucket = join(".",["www",var.subdomain_name,var.domain_name])
  website {
    redirect_all_requests_to = join("",["https://",var.subdomain_name,".",var.domain_name])
  }
  tags = var.tags
}

