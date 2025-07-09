variable "thing_name" {
  description = "The name of the IoT Thing"
  type        = string
}

variable "principal" {
  description = "The principal (certificate ARN) to attach to the IoT Thing"
  type        = string
}
