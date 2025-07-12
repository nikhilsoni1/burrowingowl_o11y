resource "aws_glue_crawler" "this" {
  name          = var.name
  role          = var.iam_role_arn
  database_name = var.catalog_database_name
  table_prefix  = var.table_prefix

  s3_target {
    path = var.s3_target_path
  }

  configuration = var.configuration

  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.schedule_expression
  tags     = var.tags
}
