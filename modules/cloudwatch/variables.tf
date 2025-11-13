variable "producer_lambda_name" {
  description = "Nombre de la función Lambda Producer"
  type        = string
}

variable "consumer_lambda_name" {
  description = "Nombre de la función Lambda Consumer"
  type        = string
}

variable "log_retention_days" {
  description = "Número de días para retener los logs (ej: 30, 90, 365)"
  type        = number
  default     = 7
}