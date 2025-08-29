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


# create KMS key for S3 bucket encryption
resource "aws_kms_key" "s3_bucket_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}


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

  enable_bucket_encryption = true
  kms_key_arn = aws_kms_key.s3_bucket_key.arn
}

module "data_bucket_policy" {
  source             = "../../modules/s3_bucket_policy"
  bucket_id          = module.data_bucket.bucket_id
  bucket_arn         = module.data_bucket.bucket_arn
  use_default_policy = true
  }


# create frontend bucket, public access blocked by default
module "frontend_bucket" {
  source              = "../../modules/s3"
  bucket_name         = "${var.environment}-secure-lab-frontend-${random_id.frontend_suffix.hex}"
  object_lock_enabled = var.objectlockTF
  versioning          = var.versioning
}

module "frontend_bucket_policy" {
  source             = "../../modules/s3_bucket_policy"
  bucket_id          = module.frontend_bucket.bucket_id
  bucket_arn         = module.frontend_bucket.bucket_arn
  use_default_policy = false
  bucket_policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/MyLambdaRole"
        }
        Action   = "s3:GetObject"
        Resource = "${module.frontend_bucket.bucket_arn}/*"
      }
    ]
  })
}

# create upload lambda
module "upload_lambda" {
  function_name       = var.upload_lambda_name
  lambda_role_arn     = aws_iam_role.lambda_s3_uploader.arn #need to add IAM
  handler             = "upload_lambda_function.lambda_handler"
  runtime            = var.upload_lambda_runtime

  source              = "../../modules/lambda"
  source_file         = "${path.module}/upload_lambda_function.py"

  environment_variables = {
    "${var.environment}_UPLOAD_BUCKET" = module.data_bucket.bucket_name
  }
}

#temp IAM for upload_lambda, needs to go into iam.terraform {
resource "aws_iam_role" "lambda_s3_uploader" {
  name = "${var.environment}-lambda-s3-uploader"

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

# upload frontend.html to frontend bucket
resource "aws_s3_object" "frontend_html" {
  bucket = module.frontend_bucket.bucket_id

  key          = "frontend.html"
  source       = "${path.module}/frontend.html"
  content_type = "text/html"

  depends_on = [
    module.cloudfront_oac.origin_access_control_id,
    module.frontend_bucket.bucket_id
  ]
}

# CloudFront Origin Access Control
module "cloudfront_oac" {
  source                     = "../../modules/cloudfront_oac"
  oac_name                   = "${var.project_name}-oac-${random_id.frontend_suffix.hex}-frontend"
  origin_type                = "s3"
  signing_behavior           = "always"
  signing_protocol           = "sigv4"
}

# Create Cloudfront (dependent on ACM, WAF, OAC)
module "cloudfront" {
  source                     = "../../modules/cloudfront"
  #default_root_object        = "frontend.html" #default set in module
  web_acl_id                 = module.waf.web_acl_id
  distribution_name          = "${var.project_name}-cdn-${var.environment}"
  origin_id                  = "S3-${module.frontend_bucket.bucket_name}"
  origin_access_control_id   = module.cloudfront_oac.origin_access_control_id
  origin_domain_name         = module.frontend_bucket.bucket_regional_domain_name
  # price_class = "PriceClass_100" #default set in module
  acm_certificate_arn        = module.acm_dns_validation.validated_certificate_arn
}


#make acm cert
module "acm_certificate" {
  source              = "../../modules/acm"
  domain_name         = var.domain_name
}

module "acm_dns_validation" {
  source                  = "../../modules/acm_dns_validation"
  certificate_arn         = module.acm_certificate.acm_certificate_arn
  domain_validation_options = module.acm_certificate.domain_validation_options
  route53_zone_id         = var.route53_zone_id
}

# 12. WAF Web ACL
#
module "waf" {
  source    = "../../modules/waf"
  waf_name  = "${module.frontend_bucket.bucket_name}-waf-${random_id.frontend_suffix.hex}"
}

# Route 53
module "route53" {
  source                    = "../../modules/route53"
  route_53_zone_id                   = var.route53_zone_id
  domain_name               = var.domain_name
  cloudfront_domain_name    = module.cloudfront.distribution_domain_name
  domain_validation_options = module.acm_certificate.domain_validation_options
}

