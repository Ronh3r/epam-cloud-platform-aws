resource "aws_sqs_queue" "book_queue" {
  name                       = "${var.sqs_project_name}-bookqueue-${var.module_environment}"
  delay_seconds              = 0
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 300 # 5 minutos para que el consumidor procese

  tags = {
    Name        = "${var.sqs_project_name}-bookqueue-${var.module_environment}"
    environment = var.module_environment
  }
}