locals {
  role_name = "${var.stack_name}-${var.app_short_name}-${terraform.workspace}-codepipeline"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.stack_name}-${var.app_short_name}-${terraform.workspace}-codepipeline"
  role_arn = module.iam_assumable_role.iam_role_arn
  artifact_store {
    location = data.aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"
      output_artifacts = ["source_output"]
      configuration = {
        S3ObjectKey = var.app_artifacts
        S3Bucket = var.codepipeline_source_bucket
        PollForSourceChanges = true
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      name     = "Deploy"
      owner    = "AWS"
      provider = "S3"
      version  = "1"
      input_artifacts = ["source_output"]
      configuration = {
        BucketName = var.codepipeline_destination_bucket
        Extract = "true"
      }
    }
  }
  tags = var.tags
}