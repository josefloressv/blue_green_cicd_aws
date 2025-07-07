locals {
  environment    = var.tags.Environment
  name_prefix    = join("-", compact([var.tags.Platform, var.base_name, var.tags.Environment]))
  dd_name_prefix = "${local.name_prefix}-datadog"
  lt_template    = var.operating_system == "linux" ? "linux_user_data.tpl" : "windows_user_data.tpl"
  aws_account_id = data.aws_caller_identity.current.account_id
}