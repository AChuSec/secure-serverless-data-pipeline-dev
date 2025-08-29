variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for CloudFront"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

# s3 module
variable "versioning" {
  type    = bool
}

variable "objectlockTF" {
  type    = bool
}

# lambda module
variable "upload_lambda_name" {
  type        = string
  description = "Name of the Upload Lambda function"
}

variable "upload_lambda_source_file" {
  type        = string
  description = "Path to the Upload Lambda source file"
}

variable "runtime" {
  type        = string
  description = "Python runtime version"
}

variable "upload_lambda_handler" {
  type        = string
  description = "Upload Lambda handler function"
}

variable "upload_lambda_runtime" {
  type        = string
  default     = "python3.12"
}

# not needed variable "upload_lambda_role_arn" {  type        = string  description = "IAM role ARN for Lambda"}

#not needed variable "environment_variables" {  type        = map(string)  default     = {}}
