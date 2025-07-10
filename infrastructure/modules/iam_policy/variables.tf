variable "name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "path" {
  description = "Path in which to create the policy"
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = ""
}

variable "policy" {
  description = "The JSON policy document"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the IAM policy"
  type        = map(string)
  default     = {}
}

