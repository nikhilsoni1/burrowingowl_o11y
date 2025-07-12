output "name" {
  description = "The name of the Glue Crawler"
  value       = aws_glue_crawler.this.name
}

output "arn" {
  description = "The ARN of the Glue Crawler"
  value       = aws_glue_crawler.this.arn
}