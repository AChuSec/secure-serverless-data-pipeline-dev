variable "versioning" {
  type        = bool
  description = "Enable versioning on the S3 bucket to preserve, retrieve, and restore every version of every object"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to be created; should be globally unique"
}

variable "object_lock_enabled" {
  type        = bool
  description = "Enable Object Lock to enforce write-once-read-many (WORM) protection for compliance use cases"
}

#variable "bucket_policy" {
#  type        = string
#  description = "Optional JSON-formatted bucket policy to attach; set to null to skip policy creation"
#}

variable "enable_bucket_encryption" {
  type        = bool
  default     = false
  description = "Whether to enable server-side encryption using KMS"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "ARN of the KMS key to use for bucket encryption; required if encryption is enabled"
}
