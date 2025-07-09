resource "aws_iot_policy_attachment" "this" {
  policy = var.policy_name
  target   = var.target
}