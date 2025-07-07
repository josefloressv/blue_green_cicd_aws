locals {
  environment                  = var.tags.Environment
  application                  = var.tags.Application
  platform                     = var.tags.Platform
  name_prefix                  = join("-", compact([var.tags.Application, var.tags.Environment, var.name_suffix]))
  name_prefix_blue             = "${local.name_prefix}-blue"
  name_prefix_green            = "${local.name_prefix}-green"
  ecs_target_resource_id       = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  ecs_target_resource_id_green = var.enable_blue_green_deployment ? "service/${var.ecs_cluster_name}/${aws_ecs_service.green[0].name}" : ""
  lb_listener_rule_live_name   = "${var.tags.Application}-${var.tags.Environment}-live"
  lb_listener_rule_test_name   = "${var.tags.Application}-${var.tags.Environment}-test"
}