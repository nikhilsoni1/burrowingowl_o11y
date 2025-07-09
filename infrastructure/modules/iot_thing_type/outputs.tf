output "arn" {
  description = "The ARN of the IoT Thing Type"
  value       = aws_iot_thing_type.this.arn
}

output "name" {
  description = "The name of the IoT Thing Type"
  value       = aws_iot_thing_type.this.name
}