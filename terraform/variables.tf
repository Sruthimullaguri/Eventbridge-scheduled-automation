variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type = string
  default = "us-east-1"
}

variable "email_endpoint" {
  description = "Email address that will receive SNS automation reports"
  type = string
}

variable "project_name" {
  description = "Project identifier used for naming AWS resources"
  type = string
  default = "eventbridge-automation"
}

variable "environment" {
  description = "Deployment environment name"
  type = string
  default = "dev"
}