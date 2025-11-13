variable "sqs_project_name" {
  description = "A **core name** or **prefix** used for the SQS Queue resource."
  type        = string
}

variable "module_environment" {
  description = "The **deployment environment** (e.g., 'dev', 'staging', or 'prod')."
  type        = string
}