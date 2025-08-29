variable "route_53_zone_id" {
  type        = string
  description = "Route 53 Hosted Zone ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the alias record"
}

variable "cloudfront_domain_name" {
  type        = string
  description = "CloudFront distribution domain name"
}

variable "cloudfront_zone_id" {
  type        = string
  default     = "Z2FDTNDATAQYW2" # Static CloudFront zone ID
  description = "CloudFront hosted zone ID"
}

variable "domain_validation_options" {
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  description = "ACM domain validation options"
}
