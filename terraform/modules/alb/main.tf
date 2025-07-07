resource "aws_lb" "main" {
  name                       = local.name_prefix
  internal                   = false
  enable_deletion_protection = false
  enable_http2               = true
  load_balancer_type         = "application"
  idle_timeout               = 30
  enable_waf_fail_open       = false

  # Network
  security_groups = var.security_groups
  subnets         = var.public_subnets
  ip_address_type = "ipv4"

  # Tags
  tags = var.tags

  # Access logs
  #   access_logs {
  #     enabled = true
  #     bucket  = "tbd"
  #     prefix  = "s3 prefix tbd"
  #   }
}