resource "aws_lambda_function" "aws_lambda" {
  function_name = var.lambda_function_name
  role          = var.lambda_execution_role_arn
  image_uri     = var.lambda_image_uri
  package_type  = "Image"
  timeout       = var.lambda_timeout
}
