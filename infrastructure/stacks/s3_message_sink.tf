locals {
  bucket_name_prefix = "burrowing-owl"
}

module "random_uuid_input" {
  source = "../modules/random_uuid"
  name   = local.bucket_name_prefix
}

module "bucket_input" {
  source      = "../modules/s3_bucket"
  bucket_name = "${local.bucket_name_prefix}-${module.random_uuid_input.random_uuid}"
  tags        = local.tags
}