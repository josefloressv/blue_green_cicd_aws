locals {
  name_prefix          = "${var.platform}-${var.environment}"
  aws_account_id       = data.aws_caller_identity.current.account_id
  public_subnets_cidr  = [var.public_subnet1_cidr, var.public_subnet2_cidr]
  private_subnets_cidr = [var.private_subnet1_cidr, var.private_subnet2_cidr]
  common_tags = {
    Platform       = var.platform
    Environment    = var.environment
    Provisioned_by = "Terraform"
  }
}