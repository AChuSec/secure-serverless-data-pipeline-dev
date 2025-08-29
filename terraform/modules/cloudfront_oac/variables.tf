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

