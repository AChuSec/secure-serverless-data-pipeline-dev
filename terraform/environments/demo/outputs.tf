#s3 bucket outputs
output "data_bucket_name" {
  description = "Name of the data S3 bucket"
  value       = module.data_bucket.bucket_name
}

output "data_bucket_arn" {
  description = "ARN of the data S3 bucket"
  value       = module.data_bucket.bucket_arn
}

output "data_bucket_id" {
  description = "ID of the data S3 bucket"
  value       = module.data_bucket.bucket_id
}

output "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  value       = module.frontend_bucket.bucket_name
}

output "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  value       = module.frontend_bucket.bucket_arn
}

output "frontend_bucket_id" {
  description = "ID of the frontend S3 bucket"
  value       = module.frontend_bucket.bucket_id
}

output "data_bucket_kms_key_arn" {
description = "ARN of the KMS key used for data S3 bucket encryption"
  value = aws_kms_key.s3_bucket_key.arn
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate"
  value       = module.acm_certificate.acm_certificate_arn
}

output "acm_certificate_domain_name" {
  description = "Domain name of the ACM certificate"
  value       = module.acm_certificate.acm_certificate_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.waf.web_acl_arn
}

output "cloudfront_oac_id" {
  description = "ID of the CloudFront Origin Access Control"
  value       = module.cloudfront_oac.origin_access_control_id
}

output "upload_lambda_function_name" {
  description = "Name of the upload Lambda function"
  value       = module.upload_lambda.function_name
}
