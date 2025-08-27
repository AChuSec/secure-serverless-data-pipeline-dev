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

variable "versioning" {
  type    = bool
}

variable "objectlockTF" {
  type    = bool
}

variable "data_bucket_policy" {
  type = string
}

variable "frontend_bucket_policy" {
  type = string
}

variable "domain_name" {
  description = "Custom domain name for CloudFront"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}
