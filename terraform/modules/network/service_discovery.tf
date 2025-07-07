
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${local.name_prefix}.local"
  description = "Cloud map zone"
  vpc         = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${local.name_prefix}-cloud-map-zone"
  })
}
