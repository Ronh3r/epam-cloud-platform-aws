variable "api_gateway_project_name" {
  description = "Prefijo para nombrar los recursos del API Gateway"
  type        = string
  default     = "BookProcessor"
}

variable "api_gateway_environment" {
  type = string
}

variable "producer_lambda_arn" {
  description = "El ARN completo de la función Lambda Producer"
  type        = string
}

variable "producer_lambda_invoke_arn" {
  description = "El ARN de invocación de la función Lambda Producer"
  type        = string
}

variable "producer_lambda_function_name" {
  description = "El nombre de la función Lambda Producer"
  type        = string
}