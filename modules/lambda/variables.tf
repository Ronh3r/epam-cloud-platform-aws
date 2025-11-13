# variable "producer_lambda_name" {
#   description = "The name of the Producer Lambda function"
#   type        = string
# }

# variable "consumer_lambda_name" {
#   description = "The name of the Consumer Lambda function"
#   type        = string
# }

variable "lambda_project_name" {
  description = "The prefix name for Lambda functions"
  type        = string
}

variable "dynamodb_arn" {
  description = "DynamoDB ARN for Lamba functions"
}

variable "dynamodb_name" {
  description = "DynamoDB Name for Lamba functions"
}

variable "sqs_queue_arn" {
  description = "SQS Queue ARN for Lamba functions"
}

variable "sqs_queue_id" {
  description = "SQS Queue ID for Lamba functions"
}

# variable "lambda_memory_size" {
#   description = "The memory size for the Lambda functions"
#   type        = number
#   default     = 128
# }

# variable "lambda_timeout" {
#   description = "The timeout for the Lambda functions in seconds"
#   type        = number
#   default     = 30
# }

# variable "sqs_queue_url" {
#   description = "The URL of the SQS queue"
#   type        = string
# }

# variable "dynamodb_table_name" {
#   description = "The name of the DynamoDB table"
#   type        = string
# }