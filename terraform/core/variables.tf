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

#region Network
variable "vpc_cidr" {
  type = string
}
variable "private_subnet1_cidr" {
  type = string
}
variable "private_subnet2_cidr" {
  type = string
}
variable "public_subnet1_cidr" {
  type = string
}
variable "public_subnet2_cidr" {
  type = string
}

#endregion

#region AMI Search
variable "ami_image_date" {
  type = string
}
variable "ami_architecture" {
  type    = string
  default = "arm64"
}
variable "ami_operating_system" {
  type    = string
  default = "linux"
}
#endregion

#region Linux ECS Cluster
# EC2 Lunch template
variable "linux_lt_instance_type" {
  type = string
}

# ASG
variable "linux_asg_min_size" {
  type = number
}
variable "linux_asg_max_size" {
  type = number
}

# Capacity Provider
variable "linux_cp_instance_warmup_period" {
  type    = number
  default = 30
}

variable "linux_cp_min_scaling_step_size" {
  type = number
}

variable "linux_cp_max_scaling_step_size" {
  type = number
}

variable "linux_cp_target_capacity" {
  type = number
}
#endregion
