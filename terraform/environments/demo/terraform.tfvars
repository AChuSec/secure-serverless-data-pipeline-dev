environment      = "demo"
aws_region       = "us-east-1"
project_name     = "secure-serverless-data-pipeline"
domain_name = "lab.achusec.click"
route53_zone_id = "Z03186543LKEWSFYJ778L"

# s3 module
versioning       = true
objectlockTF     = false
data_bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.environment}-secure-lab-data-uploads-${random_id.data_suffix.hex}/*"
      }
    ]
  })

frontend_bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })

# lambda module
upload_lambda_name = "upload-presigner"
upload_lambda_source_file = "values"
upload_lambda_handler = "upload_lambda_function.lambda_handler"
runtime = "python3.12"
# this will be set in main.tf - lambda_role_arn = 
# not needed environment_variables = {  "name" = "value"}