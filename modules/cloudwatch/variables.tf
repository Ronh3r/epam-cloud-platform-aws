variable "producer_lambda_name" {
  description = "The **specific name** of the Producer Lambda function."
  type        = string
}

variable "consumer_lambda_name" {
  description = "The **specific name** of the Consumer Lambda function."
  type        = string
}

variable "log_retention_days" {
  description = "The **number of days** to keep the CloudWatch logs (e.g., 30, 90, 365)."
  type        = number
  default     = 7
}

variable "module_environment" {
  description = "The **deployment environment** (e.g., 'dev', 'staging', or 'prod')."
  type        = string
}