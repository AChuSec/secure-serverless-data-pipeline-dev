resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id

  policy = var.use_default_policy ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowReadAccessToSpecificIAMRole"
        Effect    = "Allow"
        Principal = {
          AWS = var.read_access_principal_arn
        }
        Action    = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.bucket_arn}",
          "${var.bucket_arn}/*"
        ]
      }
    ]
  }) : var.bucket_policy
}
