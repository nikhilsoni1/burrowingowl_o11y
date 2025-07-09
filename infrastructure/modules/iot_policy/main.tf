resource "aws_iot_policy" "this" {
  name   = var.name
  policy = var.policy
  tags   = var.tags
}