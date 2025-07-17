variable "stream_name" {
  type        = string
  description = "Name of the Kinesis stream"
}

variable "shard_count" {
  type        = number
  description = "Number of shards in the Kinesis stream"
  default     = 1
}

variable "retention_period" {
  type        = number
  description = "Retention period of the Kinesis stream in hours"
  default     = 24
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Kinesis stream"
}

variable "stream_mode" {
  type        = string
  description = "Stream mode for the Kinesis stream (e.g., 'PROVISIONED' or 'ON_DEMAND')"
  default     = "PROVISIONED"
}