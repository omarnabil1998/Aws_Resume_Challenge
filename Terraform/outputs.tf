output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "lambda_function_url" {
  value = aws_lambda_function_url.resume_function.function_url
}

output "bucket_name" {
  value = aws_s3_bucket.resume_files.id
}