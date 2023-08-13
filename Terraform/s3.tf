resource "aws_s3_bucket" "resume_files" {
  bucket        = "${local.prefix}-files-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_object" "resume_files" {
  for_each     = fileset("../Resume-files/", "*")
  bucket       = aws_s3_bucket.resume_files.id
  key          = each.value
  source       = "../Resume-files/${each.value}"
  etag         = filemd5("../Resume-files/${each.value}")
  content_type = lookup(local.content_type_map, regex("\\.[^.]+$", each.value), null)

}

resource "aws_s3_object" "index_js" {
  bucket       = aws_s3_bucket.resume_files.id
  key          = "index.js"
  source       = "./index.js"
  etag         = local_file.index_js.content_md5
  content_type = "text/javascript"

  depends_on = [local_file.index_js]
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

locals {
  content_type_map = {
    ".js"   = "text/javascript"
    ".html" = "text/html"
    ".css"  = "text/css"
    ".jpg"  = "image/jpeg"
    ".png"  = "image/png"
  }
}
