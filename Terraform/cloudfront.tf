resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_files.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket.id
    origin_id                = aws_s3_bucket.resume_files.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  tags = local.common_tags

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_policy.id
    target_origin_id       = aws_s3_bucket.resume_files.id
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  aliases = ["${data.aws_route53_zone.resume.name}", "www.${data.aws_route53_zone.resume.name}"]

  depends_on = [
    aws_s3_bucket.resume_files,
    aws_cloudfront_origin_access_control.s3_bucket
  ]
}

resource "aws_cloudfront_origin_access_control" "s3_bucket" {
  name                              = aws_s3_bucket.resume_files.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingOptimized"
}