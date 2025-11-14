# 1. Grupo de Logs para la Producer Lambda
resource "aws_cloudwatch_log_group" "producer_log_group" {
  name              = "/aws/lambda/${var.producer_lambda_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.producer_lambda_name}-logs"
    Project     = "${var.producer_lambda_name}-bookapi"
    environment = var.module_environment
  }
}

# 2. Grupo de Logs para la Consumer Lambda
resource "aws_cloudwatch_log_group" "consumer_log_group" {
  name              = "/aws/lambda/${var.consumer_lambda_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.consumer_lambda_name}-logs"
    Project     = "${var.consumer_lambda_name}-bookapi"
    environment = var.module_environment
  }
}