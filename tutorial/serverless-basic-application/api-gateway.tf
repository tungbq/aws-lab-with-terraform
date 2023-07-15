# Flow: 
# New API -> Resource -> Method -> Interation -> Deployment

resource "aws_api_gateway_rest_api" "lambda" {
  name          = "serverless_lambda_gw"
}

# Resource
resource "aws_api_gateway_resource" "app_resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.lambda.id
}

# Method
resource "aws_api_gateway_method" "app_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  resource_id   = aws_api_gateway_resource.app_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integration
resource "aws_api_gateway_integration" "app_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_resource.app_resource.id
  http_method             = aws_api_gateway_method.app_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

# Deployment
resource "aws_api_gateway_deployment" "app_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.app_resource.id,
      aws_api_gateway_method.app_method.id,
      aws_api_gateway_integration.app_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Stage
resource "aws_api_gateway_stage" "lambda" {
  rest_api_id    = aws_api_gateway_rest_api.lambda.id
  deployment_id = aws_api_gateway_deployment.app_deployment.id
  stage_name            = "serverless_lambda_stage"

  # Temporarity disable logging. TODO: work on it later
  # access_log_settings { ... }
}

# Logging
# Temporarity disable logging. TODO: work on it later
