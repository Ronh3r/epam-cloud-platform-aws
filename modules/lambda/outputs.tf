output "producer_lambda_arn" {
  value = aws_lambda_function.producer.arn
}

output "producer_lambda_invoke_arn" {
  value = aws_lambda_function.producer.invoke_arn
}

output "producer_lambda_function_name" {
  value = aws_lambda_function.producer.function_name
}

output "consumer_lambda_arn" {
  value = aws_lambda_function.consumer.arn
}

output "consumer_lambda_function_name" {
  value = aws_lambda_function.consumer.function_name
}