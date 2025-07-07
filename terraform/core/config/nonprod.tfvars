# Network
vpc_cidr             = "10.20.0.0/16"
private_subnet1_cidr = "10.20.1.0/24"
private_subnet2_cidr = "10.20.2.0/24"
public_subnet1_cidr  = "10.20.101.0/24"
public_subnet2_cidr  = "10.20.102.0/24"

#region Linux ECS Cluster

# Lauch Template
# aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended --region us-east-1
ami_image_date         = "2025-06"
linux_lt_instance_type = "t4g.small" # 2 vCPU and 2 GB

# ASG
linux_asg_min_size = 1
linux_asg_max_size = 3

# Capacity Provider
linux_cp_min_scaling_step_size = 1
linux_cp_max_scaling_step_size = 1
linux_cp_target_capacity       = 100
#endregion
