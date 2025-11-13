output "producer_log_group_name" {
  description = "The **name of the CloudWatch log group** created for the Producer Lambda function."
  value       = aws_cloudwatch_log_group.producer_log_group.name
}

output "consumer_log_group_name" {
  description = "The **name of the CloudWatch log group** created for the Consumer Lambda function."
  value       = aws_cloudwatch_log_group.consumer_log_group.name
}