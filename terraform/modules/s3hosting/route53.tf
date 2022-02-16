#create route53 record for this site
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name = join(".",["www",var.domain_name])
  type = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = aws_cloudfront_distribution.www.hosted_zone_id
  }
}
#create route53 record for root domain
resource "aws_route53_record" "redirect" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name = ""
  type = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.redirect.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.hosted_zone_id
  }
}