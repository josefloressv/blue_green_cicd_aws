resource "aws_service_discovery_service" "main" {
  count = var.create_service_discovery ? 1 : 0
  name  = local.application

  dns_config {
    namespace_id = data.aws_service_discovery_dns_namespace.main[0].id

    dns_records {
      ttl  = 30
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 4
  }

  lifecycle {
    ignore_changes = [health_check_custom_config]
  }
}

data "aws_service_discovery_dns_namespace" "main" {
  count = var.create_service_discovery ? 1 : 0
  name  = var.service_discovery_namespace
  type  = "DNS_PRIVATE"
}