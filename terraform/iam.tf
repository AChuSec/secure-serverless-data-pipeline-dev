# 1. IAM Role for Lambda
resource "aws_iam_role" "lambda_s3_uploader" {
  name = "lambda-s3-uploader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2. Attach inline policy for S3 + CloudWatch Logs
resource "aws_iam_role_policy" "lambda_s3_upload_policy" {
  name = "LambdaS3UploadPolicy"
  role = aws_iam_role.lambda_s3_uploader.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow Lambda to upload to your S3 bucket
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
          # "s3:PutObjectAcl"  # only if you need custom ACLs
        ]
        Resource = "${aws_s3_bucket.secure_bucket.arn}/*"
      },
      # Allow Lambda to write to CloudWatch Logs
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
