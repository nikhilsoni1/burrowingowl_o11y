variable "name" {
  description = "Name of the Glue Catalog database"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Glue Catalog database"
  type        = map(string)
  default     = {}
}
