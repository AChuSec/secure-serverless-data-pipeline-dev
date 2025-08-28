# 12. WAF Web ACL

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