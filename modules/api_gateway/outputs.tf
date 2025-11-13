output "api_gateway_invoke_url" {
  description = "The **full URL** to invoke the API Gateway (useful for testing and local calls)."
  value       = "http://${aws_api_gateway_rest_api.rest_api.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.book_resource.path_part}"
}

output "api_gateway_rest_api_id" {
  description = "The unique **ID** of the main REST API Gateway resource."
  value       = aws_api_gateway_rest_api.rest_api.id
}