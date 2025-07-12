output "name" {
  description = "The name of the Glue Catalog database"
  value       = aws_glue_catalog_database.this.name
}

output "arn" {
  description = "The ARN of the Glue Catalog database"
  value       = aws_glue_catalog_database.this.arn
}
