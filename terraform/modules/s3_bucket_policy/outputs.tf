output "bucket_policy_id" {
  description = "The ID of the S3 bucket policy resource"
  value       = aws_s3_bucket_policy.this.id
}

output "bucket_policy_json" {
  description = "The JSON-formatted bucket policy applied to the S3 bucket"
  value       = aws_s3_bucket_policy.this.policy
}

output "bucket_policy_bucket" {
  description = "The name of the bucket the policy is attached to"
  value       = aws_s3_bucket_policy.this.bucket
}

output "read_access_principal_arn" {
  description = "The IAM principal ARN granted read access via the default policy"
  value       = var.read_access_principal_arn
}
