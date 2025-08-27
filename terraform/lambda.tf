#1. Zip the Upload Lambda Function
data "archive_file" "upload_lambda_zip" {
  type        = "zip"
  source_file = "upload_lambda_function.py"
  output_path = "lambda_upload.zip"
}

#2. Call the Lambda Function to Generate Presigned URL, allowing frontend browser to send file to S3
resource "aws_lambda_function" "upload_presigner" {
  function_name = "upload-presigner"
  role          = aws_iam_role.lambda_s3_uploader.arn
  handler       = "upload_lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename      = data.archive_file.upload_lambda_zip.output_path # file path of zip of lambda_function.py
  source_code_hash = data.archive_file.upload_lambda_zip.output_base64sha256

  environment {
    variables = {
      UPLOAD_BUCKET = aws_s3_bucket.secure_bucket.bucket
    }
  }
}