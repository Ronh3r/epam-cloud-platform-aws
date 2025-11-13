variable "aws_region" {
  description = "The **AWS Region** where resources will be created (e.g., 'us-east-1')."
  type        = string
  default     = "us-east-1"
}

variable "main_project_name" {
  description = "A **core name** used to tag or prefix most created AWS resources."
  type        = string
}

variable "environment" {
  description = "The **deployment environment** (e.g., 'dev', 'staging', or 'prod')."
  type        = string
}