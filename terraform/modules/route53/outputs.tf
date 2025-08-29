output "cloudfront_alias_fqdn" {
  value       = aws_route53_record.cloudfront_alias.fqdn
  description = "FQDN of the CloudFront alias record"
}
