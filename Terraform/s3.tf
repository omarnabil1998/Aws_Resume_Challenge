resource "aws_s3_bucket" "resume_files" {
  bucket        = "${local.prefix}-files-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "resume_files" {
  bucket = aws_s3_bucket.resume_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "template_file" "bucket_policy" {
  template = file("./templates/bucket-policy.json.tpl")

  vars = {
    bucket_name    = aws_s3_bucket.resume_files.id
    cloudfront_arn = aws_cloudfront_distribution.s3_distribution.arn
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.resume_files.id
  policy = data.template_file.bucket_policy.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.resume_files
  ]
}

data "aws_caller_identity" "current" {}
