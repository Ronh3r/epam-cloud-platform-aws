output "producer_log_group_name" {
  description = "Nombre del grupo de logs para la Producer Lambda"
  value       = aws_cloudwatch_log_group.producer_log_group.name
}

output "consumer_log_group_name" {
  description = "Nombre del grupo de logs para la Consumer Lambda"
  value       = aws_cloudwatch_log_group.consumer_log_group.name
}