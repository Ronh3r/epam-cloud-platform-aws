variable "api_gateway_project_name" {
  description = "A **prefix** used for naming the API Gateway resources."
  type        = string
  default     = "BookProcessor"
}

variable "api_gateway_environment" {
  description = "The **environment stage** for the API Gateway (e.g., 'dev', 'test', or 'prod')."
  type        = string
}

variable "producer_lambda_arn" {
  description = "The **full ARN** (Amazon Resource Name) of the producer Lambda function."
  type        = string
}

variable "producer_lambda_invoke_arn" {
  description = "The **invocation ARN** required to execute the producer Lambda function."
  type        = string
}

variable "producer_lambda_function_name" {
  description = "The **specific name** of the producer Lambda function."
  type        = string
}