
#create s3 bucket to host our site
resource "aws_s3_bucket" "this" {
  bucket = join(".",[var.subdomain_name,var.domain_name])
  versioning {
    enabled = true
  }
  force_destroy = true
  tags = var.tags
}
#create s3 bucket policy
resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.this.bucket
  policy = templatefile("${path.module}/templates/policy.json",{
    bucket_arn = aws_s3_bucket.this.arn,
    cloudfront_arn = aws_cloudfront_origin_access_identity.this.iam_arn
  } )
  depends_on = [aws_s3_bucket.this]
}
#create s3 bucket to host website logs
resource "aws_s3_bucket" "log" {
  bucket = join("-",[var.domain_name,"logs"])
  acl = "log-delivery-write"
  tags = var.tags
  force_destroy = true
}

