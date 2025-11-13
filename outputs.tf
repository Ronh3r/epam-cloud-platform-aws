output "API_URL_ENDPOINT" {
  value = module.api_gateway.api_gateway_invoke_url
}

output "SQS_QUEUE_URL" {
  value = module.sqs.sqs_queue_url
}

output "DYNAMODB_TABLE_NAME" {
  value = module.dynamodb.dynamodb_table_name
}
