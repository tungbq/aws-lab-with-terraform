# Flow: New API -> Resource -> Method -> Interation -> Deployment


resource "aws_api_gateway_rest_api" "lambda" {
  name          = "serverless_lambda_gw"
}

resource "aws_api_gateway_stage" "lambda" {
  rest_api_id    = aws_api_gateway_rest_api.lambda.id
  deployment_id = aws_api_gateway_deployment.example.id

  stage_name            = "serverless_lambda_stage"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.lambda.id
}


resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id

  triggers = {
    # redeployment = sha1(jsonencode(aws_api_gateway_rest_api.lambda.body))
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      # aws_api_gateway_method.example.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.lambda.execution_arn}/*/*"
}
