resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn  = var.event_source_arn
  function_name     = var.lambda_function_arn
  starting_position = var.starting_position
  batch_size        = var.batch_size
  enabled           = var.enabled
  maximum_batching_window_in_seconds   = var.maximum_batching_window_in_seconds
}
