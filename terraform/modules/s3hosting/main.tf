
#create s3 bucket to host our site
resource "aws_s3_bucket" "www" {
  bucket = join(".",["www",var.domain_name])
  website {
    index_document = var.index_document_name
  }
  logging {
    target_bucket = aws_s3_bucket.this.id
  }
  versioning {
    enabled = true
  }
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
  tags = var.tags
}
#create s3 bucket policy
resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.bucket
  policy = templatefile("${path.module}/templates/policy.json",{
    bucket_arn = aws_s3_bucket.www.arn,
    cloudfront_arn = aws_cloudfront_origin_access_identity.www.iam_arn
  } )
}
#create s3 bucket to host website logs
resource "aws_s3_bucket" "this" {
  bucket = join("-",[var.domain_name,"logs"])
  acl = "log-delivery-write"
  tags = var.tags
}

#create redirect to redirect http to https
resource "aws_s3_bucket" "redirect" {
  bucket = var.domain_name
  website {
    redirect_all_requests_to = join("",["https://",var.domain_name])
  }
  tags = var.tags
}

#create s3 bucket policy
resource "aws_s3_bucket_policy" "redirect" {
  bucket = aws_s3_bucket.redirect.bucket
  policy = templatefile("${path.module}/templates/policy.json",{
    bucket_arn = aws_s3_bucket.redirect.arn,
    cloudfront_arn = aws_cloudfront_origin_access_identity.redirect.iam_arn
  } )
}

