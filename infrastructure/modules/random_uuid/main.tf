resource "random_uuid" "this" {
  keepers = {
    name = var.name
  }
}