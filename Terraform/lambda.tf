resource "aws_lambda_function" "resume_function" {
  filename         = "lambda/function.zip"
  function_name    = "function"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "function.lambda_handler"
  source_code_hash = filebase64sha256("lambda/function.zip")

  runtime = "python3.8"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = file("templates/lambda-policy.json")
}

resource "aws_iam_policy" "dynamodb_table_policy" {
  name   = "dynamodb_table_policy"
  policy = file("templates/dynamodb-policy.json")
}

resource "aws_iam_role_policy_attachment" "dynamodb_table_policy" {
  policy_arn = aws_iam_policy.dynamodb_table_policy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_lambda_function_url" "resume_function" {
  function_name      = aws_lambda_function.resume_function.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    #allow_origins     = ["https://www.${aws_cloudfront_distribution.s3_distribution.domain_name}"]
    allow_origins  = ["*"]
    allow_methods  = ["*"]
    allow_headers  = ["date", "keep-alive"]
    expose_headers = ["keep-alive", "date"]
    max_age        = 86400
  }
}