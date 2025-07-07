#region Dynamic variables from deploy-infra.sh
variable "aws_region" {
  type = string
}

variable "platform" {
  type = string
}

variable "environment" {
  type = string
}
#endregion

#region App config

variable "application" {
  type = string
}

variable "name_sufix" {
  type    = string
  default = ""
}

variable "app_port" {
  type = number
}

#endregion

# Task definition
variable "task_cpu_size" {
  type = number
}
variable "task_memory_size" {
  type = number
}

variable "container_cpu_units" {
  type = number
}
variable "container_memory_hard" {
  type = number
}

variable "container_check_path" {
  type = string
}
variable "container_check_interval" {
  type = number
}

variable "container_check_timeout" {
  type = number
}

variable "container_check_retries" {
  type = number
}

variable "container_check_start_period" {
  type = number
}

# ECS service

# ECS Autoscaling
variable "task_min_number" {
  type = number
}

variable "task_max_number" {
  type = number
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
  default = 300
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
  default = 300
}

variable "task_placement_strategy_rules" {
  type = list(object({
    field = string
    type  = string
  }))
}

# Lb listener
variable "lb_listener_rule_host_header" {
  type = list(string)
}

variable "lb_listener_rule_host_header_inactive" {
  type = list(string)
}

variable "lb_listener_rule_path_pattern" {
  type    = list(string)
  default = []
}

# Target Group
variable "tg_protocol" {
  type = string
}

variable "tg_deregistration_delay" {
  type = number
}

variable "tg_slow_start" {
  type = number
}

variable "tg_health_check_interval" {
  type = number
}

variable "tg_health_check_timeout" {
  type = number
}

variable "tg_health_check_healthy_threshold" {
  type = number
}

variable "tg_health_check_unhealthy_threshold" {
  type = number
}

variable "tg_health_check_matcher" {
  type = string
}
variable "tg_health_check_path" {
  type = string
}

# Logs
variable "logs_retention_in_days" {
  type    = number
  default = 7
}
