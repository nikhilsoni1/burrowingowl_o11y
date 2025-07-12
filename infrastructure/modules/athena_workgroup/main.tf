resource "aws_athena_workgroup" "this" {
  name = var.name

  configuration {
    result_configuration {
      output_location = var.output_location

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }

    enforce_workgroup_configuration = true
    publish_cloudwatch_metrics_enabled = true
    requester_pays_enabled = false
  }

  description = var.description
  state       = "ENABLED"
  tags        = var.tags
}
