output "dynamodb_table_name" {
  description = "The **name** of the DynamoDB table used for book storage."
  value       = aws_dynamodb_table.book_storage.name
}

output "dynamodb_table_arn" {
  description = "The **full ARN** (Amazon Resource Name) of the DynamoDB table."
  value       = aws_dynamodb_table.book_storage.arn
}