output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}