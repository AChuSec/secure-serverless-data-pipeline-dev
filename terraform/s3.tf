#-------------------------
# 8. CloudFront Origin Access Control (OAC)
#-------------------------
resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "frontend-oac-${random_id.frontend_suffix.hex}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
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
