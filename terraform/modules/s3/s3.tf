# 3. S3 Data Bucket
#-------------------------
resource "aws_s3_bucket" "secure_s3_bucket" {
  bucket                = var.bucket_name
  object_lock_enabled   = var.object_lock_enabled
  policy                = var.bucket_policy
}

# Block public access for S3 bucket by default
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.secure_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 6. Frontend Bucket
#-------------------------
#resource "aws_s3_bucket" "frontend_bucket" {
#  bucket = "secure-lab-frontend-${random_id.frontend_suffix.hex}"

#  tags = {
#    Name        = "SecureLabFrontend"
#    Environment = "Dev"
#  }
#}
