#-------------------------
# CloudFront Outputs
#-------------------------
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_cdn.id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_cdn.domain_name
}

#-------------------------
# ACM Certificate Output
#-------------------------
output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  value       = aws_acm_certificate.cert.arn
}

#-------------------------
# WAF Web ACL Output
#-------------------------
output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL applied to CloudFront"
  value       = aws_wafv2_web_acl.web_acl.arn
}
