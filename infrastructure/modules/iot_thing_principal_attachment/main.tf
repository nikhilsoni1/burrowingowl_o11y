resource "aws_iot_thing_principal_attachment" "this" {
  principal = var.principal
  thing = var.thing_name
}