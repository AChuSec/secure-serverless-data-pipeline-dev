# data.tf

# Get existing S3 bucket
data "aws_s3_bucket" "frontend_bucket" {
  bucket = "secure-lab-frontend-534efe8b"
}

# Get ACM certificate by domain
data "aws_acm_certificate" "cert" {
  domain   = "lab.achusec.click"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "main" {
  name         = "achusec.click"
  private_zone = false
}


# Outputs
output "acm_cert_arn" {
  value = data.aws_acm_certificate.cert.arn
}
