variable "versioning" {
  type    = bool
}

variable "bucket_name" {
  type = string
}

variable "object_lock_enabled" {
  type    = bool
}

variable "bucket_policy" {
  type = string
}

variable "enable_bucket_encryption" {
  type        = bool
  default     = false
  description = "Whether to enable server-side encryption using KMS"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "ARN of the KMS key to use for bucket encryption"
}
