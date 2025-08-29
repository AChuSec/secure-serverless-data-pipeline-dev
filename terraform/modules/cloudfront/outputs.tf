output "distribution_id" {
  value       = aws_cloudfront_distribution.frontend_cdn.id
  description = "ID of the CloudFront distribution"
}

output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.frontend_cdn.domain_name
  description = "Domain name of the CloudFront distribution"
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.frontend_cdn
}
