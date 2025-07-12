variable "name" {
  type = string
}

variable "output_location" {
  type = string
}

variable "description" {
  type    = string
  default = "Athena workgroup for analytics"
}

variable "tags" {
  type    = map(string)
  default = {}
}
