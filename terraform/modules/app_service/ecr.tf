resource "aws_ecr_repository" "app" {
  count = var.create_ecr_repository ? 1 : 0
  name  = local.name_prefix
  tags  = var.tags
}