locals {
  shared_tags = {
    project    = "BurrowingOwl-O11y"
    owner      = "NS"
    managed_by = "terraform"
  }

  environment_tags = {
    environment = "prod"
  }

  combined_tags = {
    env_project = "${local.shared_tags.project}-${local.environment_tags.environment}"
  }

  tags = merge(local.shared_tags, local.environment_tags, local.combined_tags)
}
