resource "aws_cloudwatch_log_group" "this" {
  name = var.name
  retention_in_days = var.retention_in_days
  log_group_class = var.log_group_class
  tags = var.tags
}