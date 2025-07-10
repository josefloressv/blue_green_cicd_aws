
module "nginx_bg" {
  source = "../../modules/app_service"
  # General
  tags = local.common_tags

  # Application
  app_port = var.app_port

  # ECS service
  task_definition_arn           = aws_ecs_task_definition.main.arn
  app_container_name            = local.name_prefix
  task_placement_strategy_rules = var.task_placement_strategy_rules
  ecs_cluster_name              = local.tfcore.linux_ecs_cluster_name
  capacity_provider_name        = local.tfcore.linux_ecs_cluster_capacity_provider_name

  # Networking
  private_subnet_ids = local.tfcore.private_subnet_ids
  vpc_id             = local.tfcore.vpc_id
  vpc_cidr           = local.tfcore.vpc_cidr

  # Blue/Green Deployment
  enable_blue_green_deployment = true
  active_color                 = aws_ssm_parameter.active_color.value

  task_min_number = var.task_min_number
  task_max_number = var.task_max_number

  cpu_target_threshold          = var.cpu_target_threshold
  cpu_scaleout_cooldown_seconds = var.cpu_scaleout_cooldown_seconds
  cpu_scalein_cooldown_seconds  = var.cpu_scalein_cooldown_seconds

  memory_target_threshold          = var.memory_target_threshold
  memory_scaleout_cooldown_seconds = var.memory_scaleout_cooldown_seconds
  memory_scalein_cooldown_seconds  = var.memory_scalein_cooldown_seconds

  # Lb listener
  lb_https_listener_arn                 = local.tfcore.alb_https_listener_arn
  lb_listener_rule_host_header          = var.lb_listener_rule_host_header
  lb_listener_rule_host_header_inactive = var.lb_listener_rule_host_header_inactive
  lb_listener_rule_path_pattern         = var.lb_listener_rule_path_pattern

  # Target Group
  tg_protocol                         = var.tg_protocol
  tg_deregistration_delay             = var.tg_deregistration_delay
  tg_slow_start                       = var.tg_slow_start
  tg_health_check_interval            = var.tg_health_check_interval
  tg_health_check_timeout             = var.tg_health_check_timeout
  tg_health_check_healthy_threshold   = var.tg_health_check_healthy_threshold
  tg_health_check_unhealthy_threshold = var.tg_health_check_unhealthy_threshold
  tg_health_check_matcher             = var.tg_health_check_matcher
  tg_health_check_path                = var.tg_health_check_path

}
