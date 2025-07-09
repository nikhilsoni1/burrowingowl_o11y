variable "name" {
  description = "The name of the IoT policy"
  type        = string
}
variable "policy" {
  description = "The JSON policy document for the IoT policy"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the IoT policy"
  type        = map(string)
  default     = {}
}
