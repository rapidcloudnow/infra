data "aws_route53_zone" "zone" {
  name  = var.domain_name
}
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${join(".",[var.subdomain_name,var.domain_name])}/*"
    ]
  }
}