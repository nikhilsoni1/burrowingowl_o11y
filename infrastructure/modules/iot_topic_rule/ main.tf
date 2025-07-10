resource "aws_iot_topic_rule" "this" {
  name        = var.name
  enabled     = var.enabled
  sql         = "SELECT * FROM '${var.topic}'"
  sql_version = "2016-03-23"

  s3 {
    bucket_name = var.bucket_name
    key         = "${var.s3_key_root}/${uuid()}.json"
    role_arn    = var.role_arn
  }

  tags = var.tags
}