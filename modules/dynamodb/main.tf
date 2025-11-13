resource "aws_dynamodb_table" "book_storage" {
  name         = "${var.dynamo_project_name}-BookStorage"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "bookId"

  attribute {
    name = "bookId"
    type = "S"
  }

  tags = {
    Name = "${var.dynamo_project_name}-BookStorage"
  }
}