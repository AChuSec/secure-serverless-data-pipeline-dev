output "origin_access_control_id" {
  description = "ID of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.oac.id
}

output "origin_access_control_name" {
  description = "Name of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.oac.name
}
