resource "aws_ecs_service" "service" { # when blue/green this is blue
  name            = var.enable_blue_green_deployment ? local.name_prefix_blue : local.name_prefix
  cluster         = var.ecs_cluster_name
  task_definition = var.task_definition_arn

  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  propagate_tags          = "SERVICE"
  tags                    = var.tags

  desired_count                      = var.active_color == "blue" ? var.task_min_number : var.task_min_number_inactive
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = var.attach_to_load_balancer ? var.tg_slow_start : null
  force_new_deployment               = false
  wait_for_steady_state              = false

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.task_placement_strategy_rules
    content {
      type  = ordered_placement_strategy.value["type"]
      field = ordered_placement_strategy.value["field"]
    }
  }

  dynamic "service_registries" {
    for_each = var.create_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.main[0].arn
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.create_service_discovery ? [1] : []
    content {
      enabled   = true
      namespace = data.aws_service_discovery_dns_namespace.main[0].arn
    }
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_sg.id
    ]
  }

  # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#load_balancer-1
  dynamic "load_balancer" {
    for_each = var.attach_to_load_balancer ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.main[0].arn
      container_name   = var.app_container_name
      container_port   = var.app_port
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_count,
      task_definition,
      # capacity_provider_strategy
    ]
  }
}

resource "aws_ecs_service" "green" {
  count           = var.enable_blue_green_deployment ? 1 : 0
  name            = local.name_prefix_green
  cluster         = var.ecs_cluster_name
  task_definition = var.task_definition_arn

  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  propagate_tags          = "SERVICE"
  tags                    = var.tags

  desired_count                      = var.active_color == "green" ? var.task_min_number : var.task_min_number_inactive
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = var.tg_slow_start
  force_new_deployment               = false
  wait_for_steady_state              = false

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.task_placement_strategy_rules
    content {
      type  = ordered_placement_strategy.value["type"]
      field = ordered_placement_strategy.value["field"]
    }
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_sg.id
    ]
  }

  dynamic "load_balancer" {
    for_each = var.attach_to_load_balancer ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.green[0].arn
      container_name   = var.app_container_name
      container_port   = var.app_port
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_count,
      task_definition,
      # capacity_provider_strategy
    ]
  }
}