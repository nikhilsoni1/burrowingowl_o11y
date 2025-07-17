locals {
  stream_name_prefix = "owl-stream"

  lambda_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  lambda_logging_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = [
        module.lambda_log_group.log_group_arn,
        "${module.lambda_log_group.log_group_arn}:log-stream:*"
      ]
    }]
  })
}

# -----------------------------------------------------------------------------
# Kinesis Stream Module
# -----------------------------------------------------------------------------

module "kinesis_stream" {
  source           = "../modules/kinesis_stream"
  stream_name      = local.stream_name_prefix
  shard_count      = 1
  retention_period = 24
  stream_mode      = "PROVISIONED"
  tags             = local.tags
}

# -----------------------------------------------------------------------------
# CloudWatch Log Group for Lambda
# -----------------------------------------------------------------------------

module "lambda_log_group" {
  source             = "../modules/log_group"
  name               = "/aws/lambda/${local.stream_name_prefix}"
  retention_in_days  = 14
  tags               = local.tags
}

# -----------------------------------------------------------------------------
# IAM Role for Lambda
# -----------------------------------------------------------------------------

module "lambda_iam_role" {
  source              = "../modules/iam_role"
  name                = "lambda-${local.stream_name_prefix}"
  assume_role_policy  = local.lambda_assume_role_policy
  tags                = local.tags
}

# -----------------------------------------------------------------------------
# IAM Policy and Attachment for Logging
# -----------------------------------------------------------------------------

module "lambda_iam_policy" {
  source  = "../modules/iam_policy"
  name    = "lambda-logs-${local.stream_name_prefix}"
  policy  = local.lambda_logging_policy
  tags    = local.tags
}

module "lambda_iam_policy_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  role_name  = module.lambda_iam_role.iam_role_name
  policy_arn = module.lambda_iam_policy.iam_policy_arn
}

# -----------------------------------------------------------------------------
# Lambda Function that Logs Kinesis Payloads
# -----------------------------------------------------------------------------

module "lambda_logger" {
  source     = "../modules/lambda_function"
  name       = "logger-${local.stream_name_prefix}"
  handler    = "lambda_function.lambda_handler"
  runtime    = "python3.11"
  role_arn   = module.lambda_iam_role.iam_role_arn
  filename   = "${path.module}/../../build/lambda/kinesis_sink_to_log_group.zip"
  log_group  = module.lambda_log_group.log_group_name
  tags       = local.tags

  depends_on = [
    module.lambda_iam_policy_attachment,
    module.lambda_log_group
  ]
}

# -----------------------------------------------------------------------------
# Lambda Event Source Mapping for Kinesis → Lambda
# -----------------------------------------------------------------------------

module "lambda_kinesis_event_source" {
  source              = "../modules/lambda_event_source_mapping"
  event_source_arn    = module.kinesis_stream.kinesis_stream_arn
  lambda_function_arn = module.lambda_logger.lambda_function_arn
  batch_size          = 10
  starting_position   = "LATEST"
  enabled             = true
  maximum_batching_window_in_seconds = 5

  depends_on = [
    module.lambda_logger,
    module.kinesis_stream
  ]
}
