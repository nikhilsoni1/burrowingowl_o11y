resource "aws_lambda_function" "this" {
  function_name    = var.name
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  handler          = var.handler
  runtime          = var.runtime
  role             = var.role_arn
  timeout          = var.timeout
  memory_size      = var.memory_size

  environment {
    variables = var.environment_variables
  }

  logging_config {
    application_log_level = var.application_log_level
    log_format = var.log_format
    log_group = var.log_group
    system_log_level = var.system_log_level
  }
  
  tags = var.tags
}
