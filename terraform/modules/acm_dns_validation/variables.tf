variable "certificate_arn" {
  type = string
}

variable "domain_validation_options" {
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "route53_zone_id" {
  type = string
}
