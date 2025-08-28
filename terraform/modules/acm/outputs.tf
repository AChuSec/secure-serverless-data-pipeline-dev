output "acm_certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "ARN of the validated ACM certificate"
}
output "acm_certificate_domain_name" {
  value       = aws_acm_certificate.cert.domain_name
  description = "Domain name of the ACM certificate"
}

output "validated_certificate_arn" {
  description = "ARN of the validated ACM certificate"
  value       = aws_acm_certificate_validation.cert_validation.certificate_arn
}

output "domain_validation_options" {
  value = aws_acm_certificate.cert.domain_validation_options
}
