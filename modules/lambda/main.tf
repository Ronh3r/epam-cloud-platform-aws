# Rol de ejecución común para ambas Lambdas
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_project_name}-LambdaExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Política para permitir logs
resource "aws_iam_role_policy" "lambda_log_policy" {
  name = "${var.lambda_project_name}-LambdaLogPolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Política específica para el Producer (permite enviar a SQS)
resource "aws_iam_role_policy" "producer_sqs_policy" {
  name = "${var.lambda_project_name}-ProducerSQSPolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sqs:SendMessage"
        Effect   = "Allow"
        Resource = var.sqs_queue_arn
      }
    ]
  })
  # Depende de la creación del rol
  depends_on = [aws_iam_role.lambda_exec_role]
}

# Política específica para el Consumer (permite recibir de SQS y escribir en DynamoDB)
resource "aws_iam_role_policy" "consumer_data_policy" {
  name = "${var.lambda_project_name}-ConsumerDataPolicy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = var.sqs_queue_arn
      },
      {
        Action = [
          "dynamodb:PutItem"
        ]
        Effect   = "Allow"
        Resource = var.dynamodb_arn
      }
    ]
  })
  # Depende de la creación del rol
  depends_on = [aws_iam_role.lambda_exec_role]
}


## 1. Producer Lambda
data "archive_file" "producer_zip" {
  type        = "zip"
  source_dir  = "./lambdas/producer"
  output_path = "./lambdas/producer.zip"
}

resource "aws_lambda_function" "producer" {
  function_name    = "${var.lambda_project_name}-producer"
  filename         = data.archive_file.producer_zip.output_path
  source_code_hash = data.archive_file.producer_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "producer.handler"
  runtime          = "python3.9"
  timeout          = 30

  environment {
    variables = {
      SQS_QUEUE_URL = var.sqs_queue_id
    }
  }
}

## 2. Consumer Lambda
data "archive_file" "consumer_zip" {
  type        = "zip"
  source_dir  = "./lambdas/consumer"
  output_path = "./lambdas/consumer.zip"
}

resource "aws_lambda_function" "consumer" {
  function_name    = "${var.lambda_project_name}-Consumer"
  filename         = data.archive_file.consumer_zip.output_path
  source_code_hash = data.archive_file.consumer_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "consumer.handler"
  runtime          = "python3.9"
  timeout          = 60 # Más tiempo si la API externa es lenta

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_name
      # URL de una API de libros gratuita para el ejemplo (ej: Open Library API)
      EXTERNAL_BOOK_API = "https://openlibrary.org/api/books"
    }
  }
}

# Event Source Mapping: Conecta la SQS con la Lambda Consumer
resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.consumer.arn
  batch_size       = 10 # Procesar hasta 10 mensajes a la vez
}