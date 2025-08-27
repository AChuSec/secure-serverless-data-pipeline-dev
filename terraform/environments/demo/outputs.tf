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