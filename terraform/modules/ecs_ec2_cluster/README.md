# ECS EC2 Cluster Module

Creates an ECS cluster with EC2 capacity provider, Auto Scaling Group, and Launch Template. Supports both Linux and Windows operating systems with configurable scaling and warm pool features.

## Resources
- ECS Cluster with Container Insights enabled
- ECS Capacity Provider with managed scaling
- Auto Scaling Group with termination protection
- Launch Template with EBS optimization
- IAM Instance Profile and roles
- Warm Pool configuration for Windows instances
- Security groups for cluster communication

## Inputs
- `tags` - Resource tags
- `operating_system` - OS type ("linux" or "windows")
- `base_name` - Base name for resources
- `lt_instance_type` - EC2 instance type
- `lt_ami_id` - AMI ID for instances
- `asg_min_size` - ASG minimum size (default: 1)
- `asg_max_size` - ASG maximum size (default: 1)
- `asg_vpc_id` - VPC ID for ASG
- `private_subnets_ids` - Private subnet IDs
- `cp_target_capacity` - Target capacity percentage (default: 100)
- Additional variables for volume size, security groups, and scaling parameters

## Outputs
- `ecs_cluster_arn` - ECS cluster ARN
- `ecs_cluster_name` - ECS cluster name
- `ecs_cluster_capacity_provider_name` - Capacity provider name


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