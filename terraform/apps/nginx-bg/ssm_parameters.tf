resource "aws_ssm_parameter" "SPRING_DATASOURCE_USERNAME" {
  name  = "${local.ssm_prefix}/SPRING_DATASOURCE_USERNAME"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "SPRING_DATASOURCE_PASSWORD" {
  name  = "${local.ssm_prefix}/SPRING_DATASOURCE_PASSWORD"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "SPRING_DATASOURCE_URL" {
  name  = "${local.ssm_prefix}/SPRING_DATASOURCE_URL"
  type  = "String"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "active_color" {
  name  = "${local.ssm_prefix}/active_color"
  type  = "String"
  value = "blue" # default value, can be overridden
  lifecycle {
    ignore_changes = [value]
  }
}
