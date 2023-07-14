output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_api_gateway_stage.lambda.invoke_url
}


output "dynamo_db_arn" {
  description = "Base URL for API Gateway stage."

  value = aws_dynamodb_table.basic_dynamodb_table.arn
}
