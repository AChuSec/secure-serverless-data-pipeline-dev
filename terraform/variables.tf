# UNIQUE BUCKET NAME ACROSS ALL AWS
variable "aws_region"{
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "bucket_name" {
  description = "Unique S3 bucket name"
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

  
