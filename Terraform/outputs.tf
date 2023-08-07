output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}