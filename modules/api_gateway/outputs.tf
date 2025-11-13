output "api_gateway_invoke_url" {
  # value       = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_resource.book_resource.path}"
  # value       = "${aws_api_gateway_deployment.api_deployment.invoke_url}/${var.path_parameter_name}_value"
  value = "http://${aws_api_gateway_rest_api.rest_api.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.book_resource.path_part}"

}

output "api_gateway_rest_api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}