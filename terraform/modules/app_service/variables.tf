#region General
variable "tags" {
  type = map(string)
}


variable "app_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "name_suffix" {
  type    = string
  default = ""
}
#endregion

#region ECS service
variable "task_definition_arn" {
  type = string
}

variable "app_container_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "enable_blue_green_deployment" {
  type    = bool
  default = false
}

variable "active_color" {
  type    = string
  default = "blue"
}
#endregion

#region ECS Autoscaling
variable "ecs_cluster_name" {
  type = string
}

variable "capacity_provider_name" {
  type = string
}

variable "task_min_number" {
  type = number
}

variable "task_max_number" {
  type = number
}

variable "task_min_number_inactive" {
  type    = number
  default = 0
}

variable "task_max_number_inactive" {
  type    = number
  default = 2
}

variable "cpu_target_threshold" {
  type    = number
  default = 70
}

variable "cpu_scalein_cooldown_seconds" {
  type    = number
  default = 300
}

variable "cpu_scaleout_cooldown_seconds" {
  type    = number
  default = 60
}

variable "memory_target_threshold" {
  type    = number
  default = 70
}

variable "memory_scalein_cooldown_seconds" {
  type    = number
  default = 300
}

variable "memory_scaleout_cooldown_seconds" {
  type    = number
  default = 60
}
#endregion

# task placement strategy
variable "task_placement_strategy_rules" {
  type = list(object({
    field = string
    type  = string
  }))
  default = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "binpack"
      field = "memory"
    },
    {
      type  = "binpack"
      field = "cpu"
    }
  ]
}
#region Lb listener
variable "attach_to_load_balancer" {
  type    = bool
  default = true
}
variable "lb_http_listener_arn" {
  type    = string
  default = ""
}

variable "lb_listener_rule_host_header" {
  type    = list(string)
  default = []
}

variable "lb_listener_rule_path_pattern" {
  type    = list(string)
  default = []
}

variable "lb_listener_rule_host_header_inactive" {
  type    = list(string)
  default = []
}

# Target Group
variable "tg_protocol" {
  type    = string
  default = ""
}

variable "tg_deregistration_delay" {
  type    = number
  default = 30
}

variable "tg_slow_start" {
  type    = number
  default = 30
}

variable "tg_health_check_interval" {
  type    = number
  default = 15
}

variable "tg_health_check_timeout" {
  type    = number
  default = 5
}

variable "tg_health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "tg_health_check_unhealthy_threshold" {
  type    = number
  default = 4
}

variable "tg_health_check_matcher" {
  type    = string
  default = ""
}
variable "tg_health_check_path" {
  type    = string
  default = ""
}
#endregion

# ECR
variable "create_ecr_repository" {
  type    = bool
  default = true
}

# Service Discovery
variable "create_service_discovery" {
  type    = bool
  default = false
}

variable "service_discovery_namespace" {
  type    = string
  default = ""
}

# Security Group
variable "vpc_cidr" {
  type = string
}