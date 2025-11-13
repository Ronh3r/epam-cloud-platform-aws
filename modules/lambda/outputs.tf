output "producer_lambda_arn" {
  description = "The **full ARN** (Amazon Resource Name) of the deployed Producer Lambda function."
  value       = aws_lambda_function.producer.arn
}

output "producer_lambda_invoke_arn" {
  description = "The **invocation ARN** required to execute the Producer Lambda function."
  value       = aws_lambda_function.producer.invoke_arn
}

output "producer_lambda_function_name" {
  description = "The **specific name** of the deployed Producer Lambda function."
  value       = aws_lambda_function.producer.function_name
}

output "consumer_lambda_arn" {
  description = "The **full ARN** (Amazon Resource Name) of the deployed Consumer Lambda function."
  value       = aws_lambda_function.consumer.arn
}

output "consumer_lambda_function_name" {
  description = "The **specific name** of the deployed Consumer Lambda function."
  value       = aws_lambda_function.consumer.function_name
}