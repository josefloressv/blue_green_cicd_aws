resource "aws_autoscaling_group" "main" {
  name = local.name_prefix

  force_delete = true

  # https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#waiting-for-capacity
  wait_for_capacity_timeout = "20m"

  # Required for Capacity Providers
  protect_from_scale_in = true

  # Standard configuration
  vpc_zone_identifier     = var.private_subnets_ids
  min_size                = var.asg_min_size
  max_size                = var.asg_max_size
  default_instance_warmup = var.cp_instance_warmup_period
  enabled_metrics         = var.asg_enabled_metrics
  metrics_granularity     = "1Minute" # Enable all metrics by default

  termination_policies = [
    "OldestLaunchTemplate",
    "OldestInstance",
    "ClosestToNextInstanceHour",
    "Default"
  ]

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  # Warm pool configuration for Windows
  dynamic "warm_pool" {
    for_each = var.operating_system == "windows" ? [1] : []

    content {
      pool_state                  = "Stopped"
      max_group_prepared_capacity = 1
      min_size                    = 1

      instance_reuse_policy {
        reuse_on_scale_in = false
      }
    }
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      desired_capacity
    ]
  }

  timeouts {
    delete = "1h"
  }
}
resource "aws_ecs_cluster" "main" {
  name = local.name_prefix

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}
