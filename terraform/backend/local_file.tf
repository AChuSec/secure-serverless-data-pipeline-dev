resource "local_file" "write_outputs" {
  content  = <<EOT
s3_bucket_name = "${aws_s3_bucket.terraform_state.id}"
EOT

  filename = "${path.module}/terraform_outputs.txt"
}
