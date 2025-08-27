# Terraform version 1.10 and above is required
terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # S3 backend configuration
  backend "s3" {
    bucket       = "demo-secure-serverless-data-pipeline-terraform-state-bb581825" #fill this in based on output of backend
    key          = "terraform.tfstate" # state file will be stored in this S3 bucket at file pat
    region         = "us-east-1"
    use_lockfile = true      # S3-native locking instead of using DynamoDB table
    encrypt      = true
  }
}

# Set default tags for all AWS resources
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

#-------------------------
# 1.1 Random suffixes for unique names
#-------------------------
resource "random_id" "data_suffix" { byte_length = 4 }
resource "random_id" "frontend_suffix" { byte_length = 4 }

# create data bucket, public access blocked by default 
module "data_bucket" {
  source              = "../../modules/s3"
  bucket_name         = "${var.environment}-secure-lab-data-uploads-${random_id.data_suffix.hex}"
  object_lock_enabled = var.objectlockTF
  versioning          = var.versioning
  bucket_policy       = null
}

# create frontend bucket, public access blocked by default
module "frontend_bucket" {
  source              = "../../modules/s3"
  bucket_name         = "${var.environment}-secure-lab-frontend-${random_id.frontend_suffix.hex}"
  object_lock_enabled = var.objectlockTF
  versioning          = var.versioning
  bucket_policy       = var.frontend_bucket_policy
}


# upload frontend.html to frontend bucket
resource "aws_s3_object" "frontend_html" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "frontend.html"
  source       = "${path.module}/frontend.html"
  content_type = "text/html"

  depends_on = [
    aws_cloudfront_origin_access_control.frontend_oac,
    aws_s3_bucket_policy.frontend_bucket_policy
  ]
}