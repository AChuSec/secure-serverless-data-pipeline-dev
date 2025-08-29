variable "distribution_name" {
  type        = string
  description = "Name of the CloudFront distribution"
}

variable "origin_domain_name" {
  type        = string
  description = "Domain name of the origin (e.g., S3 bucket)"
}

variable "origin_id" {
  type        = string
  description = "Unique origin ID for CloudFront"
}

variable "origin_access_control_id" {
  type        = string
  description = "ID of the CloudFront Origin Access Control"
}

variable "web_acl_id" {
  type        = string
  description = "ARN of the WAFv2 Web ACL to attach"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for HTTPS"
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Default root object for the distribution"
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class"
}
