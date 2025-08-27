
terraform {
  backend "s3" {
    bucket       = "demo-secure-serverless-data-pipeline-tfstate-bucket"
    key          = "demo/terraform.tfstate"
    use_lockfile = true      # S3-native locking
    encrypt      = true
  }
}
