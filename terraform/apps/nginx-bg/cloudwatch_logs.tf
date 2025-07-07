resource "aws_cloudwatch_log_group" "main" {
  name              = local.name_prefix
  retention_in_days = var.logs_retention_in_days
  tags              = local.common_tags
}