variable "bucket_id" {
  type        = string
  description = "ID of the S3 bucket"
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket"
}

variable "use_default_policy" {
  type        = bool
  default     = true
  description = "Whether to apply the default read-only policy"
}

variable "read_access_principal_arn" {
  type        = string
  default     = ""
  description = "ARN of the IAM role or user allowed to read from the bucket"
}

variable "bucket_policy" {
  type        = string
  default     = ""
  description = "Custom bucket policy to apply if use_default_policy is false"
}
