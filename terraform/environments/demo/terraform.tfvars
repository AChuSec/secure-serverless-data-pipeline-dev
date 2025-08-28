environment      = "demo"
aws_region       = "us-east-1"
project_name     = "secure-serverless-data-pipeline"
domain_name = "lab.achusec.click"
route53_zone_id = "Z03186543LKEWSFYJ778L"

# s3 module
versioning       = true
objectlockTF     = false




# lambda module
upload_lambda_name = "upload-presigner"
upload_lambda_source_file = "upload_lambda_function.py"
upload_lambda_handler = "upload_lambda_function.lambda_handler"
runtime = "python3.12"
# this will be set in main.tf - lambda_role_arn = 
# not needed environment_variables = {  "name" = "value"}