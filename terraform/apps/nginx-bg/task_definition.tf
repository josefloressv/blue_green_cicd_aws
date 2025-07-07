resource "aws_ecs_task_definition" "main" {
  family                   = local.name_prefix
  execution_role_arn       = aws_iam_role.exec.arn
  task_role_arn            = aws_iam_role.task.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  tags                     = local.common_tags
  cpu                      = var.task_cpu_size
  memory                   = var.task_memory_size
  container_definitions = jsonencode([
    {
      name      = local.name_prefix,
      image     = "${local.image_repository_url}:${local.current_image_tag}"
      cpu       = var.container_cpu_units
      memory    = var.container_memory_hard
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = tostring(var.app_port)
        },
        {
          name  = "SPRING_CONFIG_IMPORT"
          value = "aws-secretsmanager:/secrets/${var.environment}/services/${var.application}"
        }
      ]
      secrets = [
        {
          name      = "SPRING_DATASOURCE_USERNAME"
          valueFrom = "${local.ssm_prefix}/SPRING_DATASOURCE_USERNAME"
        },
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = "${local.ssm_prefix}/SPRING_DATASOURCE_PASSWORD"
        },
        {
          name      = "SPRING_DATASOURCE_URL"
          valueFrom = "${local.ssm_prefix}/SPRING_DATASOURCE_URL"
        }
      ]
      mountPoints = []
      volumesFrom = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "${var.platform}-${var.application}"
        }
      }
      # Purpose: This health check ensures that the container within the task is functioning properly.
      # Scope: It runs inside the container and is used by the ECS service to determine if the container should be restarted.
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.app_port}${var.container_check_path} || exit 1"]
        interval    = var.container_check_interval
        timeout     = var.container_check_timeout
        retries     = var.container_check_retries
        startPeriod = var.container_check_start_period
      }
    }
  ])
}