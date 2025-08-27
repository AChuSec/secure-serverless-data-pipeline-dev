#1. creates a new HTTP API in AWS API Gateway v2
resource "aws_apigatewayv2_api" "upload_api" {
  name          = "UploadAPI"
  protocol_type = "HTTP"
}

#2. Integration with Upload Lambda and API Gateway, tells API Gateway what to do when a route is called 
#route - sending an HTTP request to the specific URL + method
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.upload_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.upload_presigner.invoke_arn
}

#3. Create Route for Upload
resource "aws_apigatewayv2_route" "upload_route" {
  api_id    = aws_apigatewayv2_api.upload_api.id
  route_key = "GET /generate-presigned-url"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

#4. Deploy the API
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.upload_api.id
  name        = "$default"
  auto_deploy = true
}
