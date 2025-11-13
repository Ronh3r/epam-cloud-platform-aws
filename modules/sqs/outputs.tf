output "sqs_queue_arn" {
  description = "The **full ARN** (Amazon Resource Name) of the book storage SQS Queue."
  value       = aws_sqs_queue.book_queue.arn
}

output "sqs_queue_id" {
  description = "The **unique URL/ID** of the book storage SQS Queue (required for many AWS services)."
  value       = aws_sqs_queue.book_queue.id
}

output "sqs_queue_url" {
  description = "The **full URL** of the SQS Queue, used for sending and receiving messages."
  value       = aws_sqs_queue.book_queue.url
}