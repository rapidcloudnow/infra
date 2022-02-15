resource "aws_s3_bucket_object" "this" {
  for_each = fileset(var.files_path, "*")
  bucket = data.aws_s3_bucket.this.bucket
  key    = each.value
  source = "${var.files_path}/${each.value}"
  etag   = filemd5("${var.files_path}/${each.value}")
}