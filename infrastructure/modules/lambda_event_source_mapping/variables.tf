variable "event_source_arn" {
  type        = string
  description = "ARN of the event source (e.g., Kinesis Stream ARN)"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function to trigger"
}

variable "starting_position" {
  type        = string
  description = "Starting position in the stream (e.g. LATEST, TRIM_HORIZON)"
  default     = "LATEST"
}

variable "batch_size" {
  type        = number
  description = "Number of records to send per batch"
  default     = 10
}

variable "enabled" {
  type        = bool
  description = "Whether event source mapping is enabled"
  default     = true
}

variable "maximum_batching_window_in_seconds" {
  type        = number
  description = "Maximum amount of time to wait (in seconds) to gather a full batch"
  default     = 0
}
