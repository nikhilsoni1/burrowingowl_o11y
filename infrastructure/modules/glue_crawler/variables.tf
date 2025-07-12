variable "name" {
  description = "Name of the Glue Crawler"
  type        = string
}

variable "catalog_database_name" {
  description = "The Glue Catalog database to connect to"
  type        = string
}

variable "table_prefix" {
  description = "Prefix for tables created by the crawler"
  type        = string
  default     = ""
}

variable "s3_target_path" {
  description = "S3 path the crawler scans"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM Role ARN assumed by the crawler"
  type        = string
}

variable "recrawl_behavior" {
  description = "Recrawl policy for the crawler"
  type        = string
  default     = "CRAWL_EVERYTHING"
}

variable "schedule_expression" {
  description = "Optional cron schedule expression"
  type        = string
  default     = null
}

variable "configuration" {
  description = "Crawler configuration block (as JSON string)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the crawler"
  type        = map(string)
  default     = {}
}
