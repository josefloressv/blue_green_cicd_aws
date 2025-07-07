resource "aws_lb_target_group" "main" { # when blue/green this is blue
  count = var.attach_to_load_balancer == true ? 1 : 0
  name  = var.enable_blue_green_deployment ? local.name_prefix_blue : local.name_prefix

  # Target
  vpc_id               = var.vpc_id
  target_type          = "ip"
  protocol             = var.tg_protocol
  port                 = var.app_port
  deregistration_delay = var.tg_deregistration_delay
  slow_start           = var.tg_slow_start

  # Tags
  tags = var.tags

  stickiness {
    enabled         = false
    cookie_duration = 86400
    type            = "lb_cookie"
  }

  # Purpose: This health check ensures that the load balancer routes traffic only to healthy instances of the tasks.
  # Scope: It runs at the load balancer level and checks the health of the task from an external perspective.
  health_check {
    enabled             = true
    interval            = var.tg_health_check_interval
    timeout             = var.tg_health_check_timeout
    healthy_threshold   = var.tg_health_check_healthy_threshold
    unhealthy_threshold = var.tg_health_check_unhealthy_threshold

    matcher  = var.tg_health_check_matcher
    protocol = var.tg_protocol
    port     = var.app_port
    path     = var.tg_health_check_path
  }
}

resource "aws_lb_target_group" "green" {
  count = var.enable_blue_green_deployment ? 1 : 0
  name  = local.name_prefix_green

  # Target
  vpc_id               = var.vpc_id
  target_type          = "ip"
  protocol             = var.tg_protocol
  port                 = var.app_port
  deregistration_delay = var.tg_deregistration_delay
  slow_start           = var.tg_slow_start

  # Tags
  tags = var.tags

  stickiness {
    enabled         = false
    cookie_duration = 86400
    type            = "lb_cookie"
  }

  # Purpose: This health check ensures that the load balancer routes traffic only to healthy instances of the tasks.
  # Scope: It runs at the load balancer level and checks the health of the task from an external perspective.
  health_check {
    enabled             = true
    interval            = var.tg_health_check_interval
    timeout             = var.tg_health_check_timeout
    healthy_threshold   = var.tg_health_check_healthy_threshold
    unhealthy_threshold = var.tg_health_check_unhealthy_threshold

    matcher  = var.tg_health_check_matcher
    protocol = var.tg_protocol
    port     = var.app_port
    path     = var.tg_health_check_path
  }
}
