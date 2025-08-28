variable "oac_name" {
  type        = string
  description = "OAC name"
}

variable "origin_type" {
  type        = string
  default     = "s3"
  description = "Origin type for the access control (e.g., s3, mediastore)"
}

variable "signing_behavior" {
  type        = string
  default     = "always"
  description = "Signing behavior for CloudFront requests"
}

variable "signing_protocol" {
  type        = string
  default     = "sigv4"
  description = "Signing protocol used by CloudFront"
}


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
