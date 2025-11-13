variable "aws_region" {
  description = "The AWS Region for Terraform"
  type        = string
  default     = "us-east-1"
}

variable "main_project_name" {
  description = "Prefix name for all resources"
  type        = string
}

variable "environment" {
  description = "Project environmet"
  type        = string
}
