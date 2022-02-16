#create route53 record for this site
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name = ""
  type = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
  }
}

resource "aws_route53_record" "www" {
  count =  var.env ==  "prod" ? 1 : 0
  name = "www"
  type = "CNAME"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl = "5"
  records = [var.domain_name]
}
