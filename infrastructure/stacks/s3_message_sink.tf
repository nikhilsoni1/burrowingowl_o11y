locals {
  bucket_name_prefix = "burrowing-owl"
}

module "suffix_uuid" {
  source = "../modules/random_uuid"
  name   = local.bucket_name_prefix
}

module "iot_data_sink_bucket" {
  source      = "../modules/s3_bucket"
  bucket_name = "${local.bucket_name_prefix}-${module.suffix_uuid.random_uuid}"
  tags        = local.tags
}

data "aws_iam_policy_document" "iot_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

module "iot_sink_role" {
  source              = "../modules/iam_role"
  name                = "burrowing_owl_s3_sink_role"
  assume_role_policy  = data.aws_iam_policy_document.iot_trust_policy.json
  tags                = local.tags
}

data "aws_iam_policy_document" "iot_sink_combined_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${module.iot_data_sink_bucket.bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [module.kinesis_stream.kinesis_stream_arn]
  }
}

module "iot_sink_policy" {
  source = "../modules/iam_policy"
  name   = "burrowing_owl_s3_sink_policy"
  policy = data.aws_iam_policy_document. iot_sink_combined_policy_doc.json
  tags   = local.tags
}

module "iot_sink_policy_attach" {
  source     = "../modules/iam_role_policy_attachment"
  role_name       = module.iot_sink_role.iam_role_name
  policy_arn = module.iot_sink_policy.iam_policy_arn
}

module "iot_sink_topic_rule" {
  source           = "../modules/iot_topic_rule"
  name             = "burrowing_owl_full_sink_rule"
  enabled          = true
  topic            = "topic/burrowing_owl_metrics"

  # S3 Sink
  bucket_name      = module.iot_data_sink_bucket.bucket_name
  s3_key_root      = "telemetry_data/year=$${parse_time('yyyy', timestamp())}/month=$${parse_time('MM', timestamp())}/day=$${parse_time('dd', timestamp())}/hour=$${parse_time('HH', timestamp())}/$${newuuid()}.json"
  s3_role_arn      = module.iot_sink_role.iam_role_arn

  # Kinesis Sink
  kinesis_stream_name   = module.kinesis_stream.kinesis_stream_name
  kinesis_partition_key = "static-partition"
  kinesis_role_arn      = module.iot_sink_role.iam_role_arn

  tags = local.tags
}



