output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value     = aws_cloudfront_distribution.s3_distribution.id
  sensitive = true
}

output "lambda_function_url" {
  value     = aws_lambda_function_url.resume_function.function_url
  sensitive = true
}

output "bucket_name" {
  value     = aws_s3_bucket.resume_files.id
  sensitive = true
}