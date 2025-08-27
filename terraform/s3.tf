terraform {
  required_version = ">= 1.5.0"   # Terraform CLI version (optional)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.15"       # <-- minimum provider version that supports iam_arn
    }
  }
}

#-------------------------
# 1. Provider
#-------------------------
provider "aws" {
  region = "us-east-1"
}

#-------------------------
# 1.1 Random suffixes for unique names
#-------------------------
resource "random_id" "data_suffix" { byte_length = 4 }
resource "random_id" "frontend_suffix" { byte_length = 4 }

#-------------------------
# 2. KMS Key for data bucket encryption
#-------------------------
resource "aws_kms_key" "s3_bucket_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}

#-------------------------
# 3. S3 Data Bucket
#-------------------------
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-lab-data-uploads-${random_id.data_suffix.hex}"
  object_lock_enabled = true
}

#-------------------------
# 4. Server-side encryption for data bucket
#-------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#-------------------------
# 5. Block public access for data bucket
#-------------------------
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#-------------------------
# 6. Frontend Bucket
#-------------------------
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "secure-lab-frontend-${random_id.frontend_suffix.hex}"

  tags = {
    Name        = "SecureLabFrontend"
    Environment = "Dev"
  }
}

#-------------------------
# 7. Block public access for frontend bucket
#-------------------------
resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#-------------------------
# 8. CloudFront Origin Access Control (OAC)
#-------------------------
resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "frontend-oac-${random_id.frontend_suffix.hex}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#-------------------------
# 9. Frontend Bucket Policy for CloudFront OAC
#-------------------------
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
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
}


# 10. ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 11. ACM Certificate Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn

  # Let Terraform automatically create DNS validation records in Route53
  validation_record_fqdns = [
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name
  ]
}

#-------------------------
# 12. WAF Web ACL
#-------------------------
resource "aws_wafv2_web_acl" "web_acl" {
  name        = "${var.bucket_name}-waf-${random_id.frontend_suffix.hex}"
  scope       = "CLOUDFRONT"
  description = "WAF ACL for frontend website"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webACL"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

#-------------------------
# 13. CloudFront Distribution (attach WAF)
#-------------------------
resource "aws_cloudfront_distribution" "frontend_cdn" {
  enabled             = true
  default_root_object = "frontend.html"
  web_acl_id          = aws_wafv2_web_acl.web_acl.arn

  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.frontend_bucket.bucket}"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.frontend_bucket.bucket}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

#-------------------------
# 14. Upload frontend.html to frontend bucket
#-------------------------
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
