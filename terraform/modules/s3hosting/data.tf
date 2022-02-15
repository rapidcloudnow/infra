data "aws_route53_zone" "zone" {
  name  = var.domain_name
}

#get managed s3cors policy
data "aws_cloudfront_origin_request_policy" "s3_cors" {
  id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
}
#get managed cloudfront distribution
data "aws_cloudfront_cache_policy" "managed_cache" {
  name = "Managed-CachingOptimized"
}
data "aws_acm_certificate" "this" {
  domain = var.domain_name
  types       = ["AMAZON_ISSUED"]
}