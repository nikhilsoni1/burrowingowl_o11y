output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}

output "client_id" {
  value = module.burrowing_owl.default_client_id
}
