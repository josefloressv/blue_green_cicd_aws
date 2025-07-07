# Network Module

Creates a VPC with public and private subnets across two availability zones, including NAT gateway for private subnet internet access and service discovery namespace.

## Resources
- VPC with DNS support enabled
- 2 public subnets (multi-AZ)
- 2 private subnets (multi-AZ)
- Internet Gateway
- NAT Gateway with Elastic IP
- Route tables and associations
- Service Discovery private DNS namespace

## Outputs
- `vpc_id` - VPC ID
- `vpc_arn` - VPC ARN  
- `private_subnet_ids` - List of private subnet IDs
- `public_subnet_ids` - List of public subnet IDs

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