output "default_client_id" {
  description = "The default client ID for the IoT thing"
  value       = aws_iot_thing.this.default_client_id
}

output "version" {
  description = "The version of the IoT thing"
  value       = aws_iot_thing.this.version
}

output "arn" {
  description = "The ARN of the IoT thing"
  value       = aws_iot_thing.this.arn
}

output "name" {
  description = "The name of the IoT thing"
  value       = aws_iot_thing.this.name
}