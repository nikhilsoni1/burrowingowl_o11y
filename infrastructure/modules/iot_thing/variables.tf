variable "name" {
    description = "The name of the IoT thing"
    type        = string
}

variable "attributes" {
    description = "A map of attributes to associate with the IoT thing"
    type        = map(string)
    default     = {}
}

variable "thing_type_name" {
    description = "The name of the thing type to associate with the IoT thing"
    type        = string
    default     = ""
}
