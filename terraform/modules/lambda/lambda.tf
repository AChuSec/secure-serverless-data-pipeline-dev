#1. Zip the Lambda Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/lambda_${var.function_name}.zip"
}

#2. Create the Lambda Function 
resource "aws_lambda_function" "lambda" {
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = var.function_name

  handler          = var.handler
  role             = var.lambda_role_arn
  runtime          = var.runtime
  filename         = data.archive_file.lambda_zip.output_path

  environment {
    variables = var.environment_variables
  }
}
