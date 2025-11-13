variable "lambda_project_name" {
  description = "A **prefix** used for naming the Lambda functions in this project."
  type        = string
}

variable "dynamodb_arn" {
  description = "The **ARN** (Amazon Resource Name) of the DynamoDB table required by the Lambda functions."
  type        = string
}

variable "dynamodb_name" {
  description = "The **name** of the DynamoDB table required by the Lambda functions."
  type        = string
}

variable "sqs_queue_arn" {
  description = "The **ARN** (Amazon Resource Name) of the SQS Queue required by the Lambda functions."
  type        = string
}

variable "sqs_queue_id" {
  description = "The **URL or ID** of the SQS Queue required by the Lambda functions."
  type        = string
}