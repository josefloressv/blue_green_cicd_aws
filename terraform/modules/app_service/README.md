# App Service Module

Creates ECS services with Blue/Green deployment capabilities, auto-scaling, load balancer integration, and service discovery. Supports both single and dual-environment deployments for containerized applications.

## Resources
- **ECS Services**: Blue and Green services for zero-downtime deployments
- **Target Groups**: ALB target groups with health checks for both environments
- **ALB Listener Rules**: Traffic routing rules with host header and path pattern matching
- **Auto Scaling**: CPU and memory-based scaling policies with configurable thresholds
- **ECR Repository**: Optional container image repository
- **Security Groups**: ECS task security groups with configurable ingress rules
- **Service Discovery**: AWS Service Discovery integration for service-to-service communication
- **Service Connect**: ECS Service Connect configuration for enhanced networking

## Key Features
- **Blue/Green Deployments**: Seamless zero-downtime deployments with traffic switching
- **Auto Scaling**: Automatic scaling based on CPU and memory utilization
- **Health Checks**: Configurable ALB health checks with custom paths and response codes
- **Task Placement**: Intelligent task placement across availability zones with resource optimization
- **Service Discovery**: Private DNS namespace integration for microservices communication

## Inputs

### General Configuration
- `tags` - Resource tags (map of strings)
- `aws_region` - AWS region
- `app_port` - Application port number
- `vpc_id` - VPC ID
- `vpc_cidr` - VPC CIDR block
- `name_sufix` - Name suffix for resources

### ECS Configuration
- `task_definition_arn` - ECS task definition ARN
- `ecs_cluster_id` - ECS cluster ID
- `ecs_cluster_name` - ECS cluster name
- `capacity_provider_name` - ECS capacity provider name
- `private_subnet_ids` - Private subnet IDs (list)

### Blue/Green Deployment
- `enable_blue_green_deployment` - Enable Blue/Green deployment (default: false)
- `active_color` - Active color for Blue/Green (default: "blue")

### Auto Scaling
- `task_min_number` - Minimum number of tasks
- `task_max_number` - Maximum number of tasks
- `task_min_number_inactive` - Minimum tasks for inactive environment (default: 0)
- `task_max_number_inactive` - Maximum tasks for inactive environment (default: 2)
- `cpu_target_threshold` - CPU utilization target (default: 70)
- `cpu_scalein_cooldown_seconds` - CPU scale-in cooldown (default: 300)
- `cpu_scaleout_cooldown_seconds` - CPU scale-out cooldown (default: 60)
- `memory_target_threshold` - Memory utilization target (default: 70)
- `memory_scalein_cooldown_seconds` - Memory scale-in cooldown (default: 300)
- `memory_scaleout_cooldown_seconds` - Memory scale-out cooldown (default: 60)

### Load Balancer Configuration
- `attach_to_load_balancer` - Attach to ALB (default: true)
- `lb_http_listener_arn` - ALB HTTP listener ARN
- `lb_listener_rule_host_header` - Host header values for routing (list)
- `lb_listener_rule_path_pattern` - Path pattern values for routing (list)
- `lb_listener_rule_host_header_inactive` - Host header for inactive environment (list)

### Target Group Settings
- `tg_protocol` - Target group protocol
- `tg_deregistration_delay` - Deregistration delay in seconds (default: 30)
- `tg_slow_start` - Slow start duration in seconds (default: 30)
- `tg_health_check_interval` - Health check interval (default: 15)
- `tg_health_check_timeout` - Health check timeout (default: 5)
- `tg_health_check_healthy_threshold` - Healthy threshold (default: 2)
- `tg_health_check_unhealthy_threshold` - Unhealthy threshold (default: 4)
- `tg_health_check_matcher` - Health check response matcher
- `tg_health_check_path` - Health check path

### Service Discovery
- `create_service_discovery` - Create service discovery (default: false)
- `service_discovery_namespace` - Service discovery namespace name

### ECR Configuration
- `create_ecr_repository` - Create ECR repository (default: true)

### Task Placement Strategy
- `task_placement_strategy_rules` - Task placement rules (default: spread by AZ, binpack by memory/CPU)

## Outputs
This module creates resources but does not explicitly define outputs. Resources created include:
- ECS service ARNs and names
- Target group ARNs
- Security group IDs
- ECR repository URL (if created)
- Service discovery service ARN (if created)

## Usage Example

```hcl
module "app_service" {
  source = "./modules/app_service"
  
  # General
  tags = {
    Application = "my-app"
    Environment = "prod"
    Platform    = "demo"
  }
  
  # ECS
  task_definition_arn     = aws_ecs_task_definition.app.arn
  ecs_cluster_id          = module.ecs_cluster.ecs_cluster_arn
  ecs_cluster_name        = module.ecs_cluster.ecs_cluster_name
  capacity_provider_name  = module.ecs_cluster.capacity_provider_name
  
  # Networking
  vpc_id              = module.network.vpc_id
  vpc_cidr            = "10.0.0.0/16"
  private_subnet_ids  = module.network.private_subnet_ids
  
  # Application
  app_port    = 8080
  name_sufix  = "api"
  
  # Blue/Green
  enable_blue_green_deployment = true
  active_color                 = "blue"
  
  # Scaling
  task_min_number = 2
  task_max_number = 10
  
  # Load Balancer
  lb_http_listener_arn           = module.alb.http_listener_arn
  lb_listener_rule_host_header   = ["api.example.com"]
  lb_listener_rule_path_pattern  = ["/api/*"]
  
  # Target Group
  tg_protocol              = "HTTP"
  tg_health_check_path     = "/health"
  tg_health_check_matcher  = "200"
}
```


## How to work

```bash
# Initialize - Download and install provider plugins and modules
terraform init -upgrade

# Plan - Preview changes that will be made to infrastructure
terraform plan

# Apply - Create/update infrastructure resources
terraform apply

# Destroy - Remove all created infrastructure resources
terraform destroy

# Format - Automatically format Terraform files for consistency
terraform fmt
```