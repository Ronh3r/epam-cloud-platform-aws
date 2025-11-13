# 1. Grupo de Logs para la Producer Lambda
# Convención de nombres de AWS: /aws/lambda/<nombre-de-la-funcion>
resource "aws_cloudwatch_log_group" "producer_log_group" {
  name              = "/aws/lambda/${var.producer_lambda_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name    = "${var.producer_lambda_name}-Logs"
    Project = "BookProcessor"
  }
}

# 2. Grupo de Logs para la Consumer Lambda
resource "aws_cloudwatch_log_group" "consumer_log_group" {
  name              = "/aws/lambda/${var.consumer_lambda_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name    = "${var.consumer_lambda_name}-Logs"
    Project = "BookProcessor"
  }
}