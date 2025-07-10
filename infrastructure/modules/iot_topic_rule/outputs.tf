
output "id" {
  description = "The id of the topic rule"
  value       = aws_iot_topic_rule.this.id
  
}
output "arn" {
  description = "The ARN of the topic rule"
  value       = aws_iot_topic_rule.this.arn
  
}