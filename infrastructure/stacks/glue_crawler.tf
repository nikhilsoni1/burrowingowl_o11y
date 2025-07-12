# Glue Crawler Assume Role Policy
data "aws_iam_policy_document" "glue_crawler_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Glue Crawler IAM Role
module "glue_crawler_role" {
  source              = "../modules/iam_role"
  name                = "burrowing_owl_glue_crawler_role"
  assume_role_policy  = data.aws_iam_policy_document.glue_crawler_trust.json
  tags                = local.tags
}

# Attach AWS Managed Glue Service Role Policy
module "glue_service_role_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  role_name  = module.glue_crawler_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Custom S3 Data Access Policy for Crawler
data "aws_iam_policy_document" "glue_crawler_s3_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "${module.iot_data_sink_bucket.bucket_arn}",
      "${module.iot_data_sink_bucket.bucket_arn}/*"
    ]
  }
}

# Create IAM Policy from Access Document
module "glue_crawler_s3_policy" {
  source = "../modules/iam_policy"
  name   = "glue_crawler_s3_access"
  policy = data.aws_iam_policy_document.glue_crawler_s3_access.json
  tags   = local.tags
}

# Attach S3 Access Policy to Glue Crawler Role
module "glue_crawler_s3_policy_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  role_name  = module.glue_crawler_role.iam_role_name
  policy_arn = module.glue_crawler_s3_policy.iam_policy_arn
}

module "telemetry_db" {
  source = "../modules/glue_catalog_database"
  name   = "burrowing_owl_telemetry"
  tags   = local.tags
}

locals {
  glue_crawler_configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })
}


module "telemetry_crawler" {
  source = "../modules/glue_crawler"
  name                  = "burrowing_owl_telemetry_crawler"
  catalog_database_name = module.telemetry_db.name
  s3_target_path        = "s3://${module.iot_data_sink_bucket.bucket_name}/telemetry_data/"
  iam_role_arn          = module.glue_crawler_role.iam_role_arn
  table_prefix          = ""
  configuration         = local.glue_crawler_configuration
  schedule_expression   = "cron(0 * * * ? *)"
  tags                  = local.tags
}