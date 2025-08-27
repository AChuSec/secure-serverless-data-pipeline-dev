variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "source_file" {
  type        = string
  description = "Path to the Lambda source file"
}

variable "handler" {
  type        = string
  description = "Lambda handler function"
}

variable "runtime" {
  type        = string
  default     = "python3.12"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for Lambda"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
}

