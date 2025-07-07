
resource "aws_secretsmanager_secret" "standings" {
  name        = "/secrets/${var.environment}/services/${var.application}"
  description = "Demo Configuration"
}
