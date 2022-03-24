variable "app_name" {
  description = "Name of the application."
  type        = string

  validation {
    condition     = length(var.app_name) >= 3 && can(regex("^[^-][A-Za-z0-9-]*[^-]$", var.app_name))
    error_message = "The app_name value must be longer than 3 characters and can only contain letters, numbers, and dashes."
  }
}

variable "aws_region" {
  description = "Aws region to deploy the resources."
  type        = string
}

variable "base_url" {
  description = "Base URL for the application, all other URLs will be relative to this."
  type        = string
}

variable "commit_hash" {
  description = "Hash of the lastest commit that will be deployed"
  type        = string
}

variable "current_stage" {
  description = "Either prod, dev or preview"
  type        = string
}

variable "lambda_bucket_name" {
  description = "Lambda Bucket Name"
  type        = string
}

variable "lambda_gateway_name" {
  description = "Lambda Gateway Name"
  type        = string
}

variable "pr_id" {
  description = "Pull Request ID"
  type        = string
}
