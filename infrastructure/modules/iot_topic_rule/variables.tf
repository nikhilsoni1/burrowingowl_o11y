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

# S3 Sink Configuration
variable "bucket_name" {
  description = "The name of the S3 bucket to store messages"
  type        = string
}

variable "s3_key_root" {
  description = "Root path in the S3 key where IoT messages are stored"
  type        = string
}

variable "s3_role_arn" {
  description = "IAM Role ARN that allows IoT to write to S3"
  type        = string
}

# Kinesis Sink Configuration
variable "kinesis_stream_name" {
  description = "Name of the Kinesis stream to send IoT messages to"
  type        = string
}

variable "kinesis_role_arn" {
  description = "IAM Role ARN that allows IoT to write to Kinesis"
  type        = string
}

variable "kinesis_partition_key" {
  description = "Partition key used when writing to Kinesis"
  type        = string
}

# Tags
variable "tags" {
  description = "Tags to apply to the IoT topic rule"
  type        = map(string)
  default     = {}
}
