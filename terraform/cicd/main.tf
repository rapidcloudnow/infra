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
        PollForSourceChanges = false
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

resource "aws_cloudwatch_event_rule" "s3" {
  name        =  "${var.stack_name}-${var.app_short_name}-${terraform.workspace}-codepipeline-event-rule"
  description = "Capture s3 activities"

  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "CopyObject",
      "CompleteMultipartUpload",
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${var.codepipeline_source_bucket}"
      ],
      "key": [
        "${var.app_artifacts}"
      ]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.s3.name
  target_id = "BuildCodePipeline"
  arn       = aws_codepipeline.codepipeline.arn
}