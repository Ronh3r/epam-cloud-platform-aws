resource "aws_dynamodb_table" "book_storage" {
  name         = "${var.dynamo_project_name}-bookstorage-${var.module_environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "bookId"

  attribute {
    name = "bookId"
    type = "S"
  }

  tags = {
    Name        = "${var.dynamo_project_name}-bookstorage-${var.module_environment}"
    environment = var.module_environment
  }
}