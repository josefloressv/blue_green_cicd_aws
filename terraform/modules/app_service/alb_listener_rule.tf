resource "aws_lb_listener_rule" "main" { # when blue/green this is blue
  count        = var.attach_to_load_balancer == true ? 1 : 0
  listener_arn = var.lb_http_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
  condition {
    host_header {
      values = var.active_color == "blue" ? var.lb_listener_rule_host_header : var.lb_listener_rule_host_header_inactive
    }
  }
  condition {
    path_pattern {
      values = var.lb_listener_rule_path_pattern
    }
  }
  tags = merge(var.tags, {
    "Name" = var.active_color == "blue" ? local.lb_listener_rule_live_name : local.lb_listener_rule_test_name
  })
}

resource "aws_lb_listener_rule" "green" {
  count        = var.enable_blue_green_deployment ? 1 : 0
  listener_arn = var.lb_http_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green[0].arn
  }
  condition {
    host_header {
      values = var.active_color == "green" ? var.lb_listener_rule_host_header : var.lb_listener_rule_host_header_inactive
    }
  }
  tags = merge(var.tags, {
    "Name" = var.active_color == "green" ? local.lb_listener_rule_live_name : local.lb_listener_rule_test_name
  })

  depends_on = [aws_lb_target_group.green[0]]
}