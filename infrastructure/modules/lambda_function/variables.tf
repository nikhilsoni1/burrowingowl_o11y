variable "name" {
  description = "Lambda function name"
  type        = string
}

variable "filename" {
  description = "Path to the zipped Lambda function"
  type        = string
}

variable "handler" {
  description = "Lambda function handler (e.g. lambda_function.lambda_handler)"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g. python3.11)"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Function memory in MB"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "application_log_level" {
  description = "Application log level for the Lambda function"
  type        = string
  default     = "INFO"
}

variable "log_format" {
  description = "Log format for the Lambda function"
  type        = string
  default     = "JSON"
}

variable "log_group" {
  description = "Log group for the Lambda function"
  type        = string
}

variable "system_log_level" {
  description = "System log level for the Lambda function"
  type        = string
  default     = "INFO"
}


