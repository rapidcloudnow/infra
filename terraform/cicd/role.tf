module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"
  trusted_role_services = [
    "codepipeline.amazonaws.com",
    "events.amazonaws.com"
  ]
  create_role = true
  role_name = local.role_name
  role_requires_mfa = false
  custom_role_policy_arns = [
   aws_iam_policy.codepipeline_policy.arn
  ]
  number_of_custom_role_policy_arns = 1
}
resource "aws_iam_policy" "codepipeline_policy" {
  policy = data.aws_iam_policy_document.codepipeline_service_role.json
  name = "${var.stack_name}-${var.app_short_name}-${terraform.workspace}-codepipeline-policy"
}