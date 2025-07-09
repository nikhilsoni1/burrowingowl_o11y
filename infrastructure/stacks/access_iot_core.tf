provider "aws" {
  region = "us-east-1"
}


module "type_raspberrypi" {
  source = "../modules/iot_thing_type"
  name        = "raspberrypi"
  description = "Raspberry Pi IoT Thing Type"
  tags        = local.tags
}

module "burrowing_owl" {
  source = "../modules/iot_thing"
  name   = "burrowing_owl"
  thing_type_name = module.type_raspberrypi.name
}

module "cert" {
    source = "../modules/iot_certificate"
    active = true
}

module "attach_principal" {
  source = "../modules/iot_thing_principal_attachment"
  principal = module.cert.arn
  thing_name = module.burrowing_owl.name
}

resource "local_file" "private_key" {
  content         = module.cert.private_key
  filename        = "${path.root}/../../certs/private.pem.key"
  file_permission = "0600"
}

resource "local_file" "certificate_pem" {
  content         = module.cert.certificate_pem
  filename        = "${path.root}/../../certs/device.pem.crt"
  file_permission = "0644"
}

resource "local_file" "public_key" {
  content         = module.cert.public_key
  filename        = "${path.root}/../../certs/public.pem.key"
  file_permission = "0644"
}


data "aws_iam_policy_document" "iot_policy" {
  statement {
    actions = [
      "iot:Connect",
      "iot:Publish",
      "iot:Subscribe",
      "iot:Receive"
    ]
    resources = [
      module.burrowing_owl.arn
    ]
  }
}

module "policy" {
  source = "../modules/iot_policy"
  name   = "burrowing_owl_policy"
  policy = data.aws_iam_policy_document.iot_policy.json
  tags = local.tags
}

module "attach_policy" {
  source = "../modules/iot_policy_attachment"
  policy_name = module.policy.name
  target      = module.cert.arn
}