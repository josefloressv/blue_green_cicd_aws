output "active_color" {
  value = nonsensitive(aws_ssm_parameter.active_color.value)
}