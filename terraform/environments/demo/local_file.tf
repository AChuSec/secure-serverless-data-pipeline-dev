resource "local_file" "write_outputs" {
  content  = <<EOT
data_bucket_name     = "${module.data_bucket.bucket_name}"
data_bucket_arn      = "${module.data_bucket.bucket_arn}"
data_bucket_id       = "${module.data_bucket.bucket_id}"
frontend_bucket_name = "${module.frontend_bucket.bucket_name}"
frontend_bucket_arn  = "${module.frontend_bucket.bucket_arn}"
frontend_bucket_id   = "${module.frontend_bucket.bucket_id}"
EOT

  filename = "${path.module}/terraform_outputs.txt"
}