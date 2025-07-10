variable "name" {
  description = "The name of the IoT topic rule"
  type        = string
  
}

variable "enabled" {
  description = "Whether the IoT topic rule is enabled"
  type        = bool
  default     = true
}

variable "topic" {
  description = "The MQTT topic to subscribe to"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store messages"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to assume"
  type        = string
}

variable "s3_key_root" {
  type        = string
  default     = "iot_data"
  description = "Root path in the S3 key where IoT messages are stored"
}

variable "tags" {
  description = "Tags to apply to the IoT topic rule"
  type        = map(string)
  default     = {}
}