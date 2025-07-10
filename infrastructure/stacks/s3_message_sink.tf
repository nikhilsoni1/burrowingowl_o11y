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

data "aws_iam_policy_document" "iot_sink_s3_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${module.iot_data_sink_bucket.bucket_arn}/*"
    ]
  }
}

module "iot_sink_s3_policy" {
  source = "../modules/iam_policy"
  name   = "burrowing_owl_s3_sink_policy"
  policy = data.aws_iam_policy_document.iot_sink_s3_policy_doc.json
  tags   = local.tags
}

module "iot_sink_policy_attach" {
  source     = "../modules/iam_role_policy_attachment"
  role_name       = module.iot_sink_role.iam_role_name
  policy_arn = module.iot_sink_s3_policy.iam_policy_arn
}

module "iot_sink_topic_rule" {
  source      = "../modules/iot_topic_rule"
  name        = "burrowing_owl_s3_sink_rule"
  enabled     = true
  topic       = "topic/burrowing_owl_metrics"
  bucket_name = module.iot_data_sink_bucket.bucket_name
  role_arn    = module.iot_sink_role.iam_role_arn
  s3_key_root = "telemetry_data/$${parse_time('yyyy', timestamp())}/$${parse_time('MM', timestamp())}/$${parse_time('dd', timestamp())}/$${parse_time('HH', timestamp())}/$${newuuid()}.json"
  tags        = local.tags
}