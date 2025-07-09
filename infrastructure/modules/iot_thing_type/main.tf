resource "aws_iot_thing_type" "this" {
    name = var.name
    deprecated = var.deprecated
    properties {
      description = var.description
      searchable_attributes = var.searchable_attributes
    }
    tags = var.tags
}
