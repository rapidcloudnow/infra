#Cloudfront for this s3 site
locals {
  www_origin_id = "www.${var.domain_name}"
  redict_orgin_id  = "redict.${var.domain_name}"
}
# create origin access identity
resource "aws_cloudfront_origin_access_identity" "www" {
  comment = "origin access for rcn www"
}
# create origin access identity
resource "aws_cloudfront_origin_access_identity" "redirect" {
  comment = "origin access for rcn redirect"
}
resource "aws_cloudfront_distribution" "www" {
  enabled = true
  is_ipv6_enabled = true
  wait_for_deployment = false
  comment             = "rapid cloud now"
  default_root_object = var.index_document_name
#  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.www.bucket_domain_name
    origin_id = local.www_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.www.cloudfront_access_identity_path
    }
  }

  aliases = ["www.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/404.html"
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.www_origin_id
    cache_policy_id = data.aws_cloudfront_cache_policy.managed_cache.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
  tags = var.tags
  depends_on = [aws_s3_bucket.www]
}

# Cloudfront S3 for redirect to www.
resource "aws_cloudfront_distribution" "redirect" {
  origin {
    domain_name = aws_s3_bucket.redirect.bucket_domain_name
    origin_id = local.redict_orgin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled = true
  is_ipv6_enabled = true
  aliases = [var.domain_name]
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.redict_orgin_id

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
      headers = ["Origin"]
    }
    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
  tags = var.tags
  depends_on = [aws_s3_bucket.redirect]
}