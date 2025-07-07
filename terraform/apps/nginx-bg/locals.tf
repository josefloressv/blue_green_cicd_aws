locals {
  deploy_type    = var.environment == "prod" ? "prod" : "nonprod"
  name_prefix    = "${var.application}-${var.environment}${var.name_sufix}"
  ssm_prefix     = "/${var.platform}/${var.application}/${var.environment}"
  aws_account_id = data.aws_caller_identity.current.account_id
  # image_repository_url = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.name_prefix}"
  image_repository_url = "nginx"
  current_image_tag    = "latest"
  common_tags = {
    Platform       = var.platform
    Application    = var.application
    Environment    = var.environment
    Provisioned_by = "Terraform"
  }
  tfcore = data.terraform_remote_state.core.outputs
}