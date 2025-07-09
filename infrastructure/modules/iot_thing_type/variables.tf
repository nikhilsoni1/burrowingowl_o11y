variable "name" {
    description = "The name of the IoT thing type"
    type        = string
}

variable "deprecated" {
    description = "Whether the IoT thing type is deprecated"
    type        = bool
    default     = false
}

variable "description" {
    description = "The description of the IoT thing type"
    type        = string
    default     = ""
}

variable "searchable_attributes" {
    description = "A list of searchable attributes for the IoT thing type"
    type        = list(string)
    default     = []
}

variable "tags" {
    description = "A map of tags to assign to the IoT thing type"
    type        = map(string)
    default     = {}
}
