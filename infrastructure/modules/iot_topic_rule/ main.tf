resource "aws_iot_topic_rule" "this" {
  name        = var.name
  enabled     = var.enabled
  sql         = "SELECT * FROM '${var.topic}'"
  sql_version = "2016-03-23"

  s3 {
    bucket_name = var.bucket_name
    key         = var.s3_key_root
    role_arn    = var.s3_role_arn
  }

  kinesis {
    stream_name   = var.kinesis_stream_name
    role_arn      = var.kinesis_role_arn
    partition_key = var.kinesis_partition_key
  }

  tags = var.tags
}
