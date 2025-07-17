variable "name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the CloudWatch Log Group"
  type        = map(string)
  default     = {}
}

variable "retention_in_days" {
  description = "The number of days to retain log events in the CloudWatch Log Group"
  type        = number
  default     = 14
}

variable "log_group_class" {
  description = "The class of the CloudWatch Log Group (e.g., 'Standard', 'InfrequentAccess')"
  type        = string
  default     = "STANDARD"
}
