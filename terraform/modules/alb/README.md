# Application Load Balancer (ALB) Module

Creates an internet-facing Application Load Balancer with HTTP and HTTPS listeners. Configured with modern TLS security policy and default 404 responses for unmatched requests.

## Resources
- Application Load Balancer (internet-facing)
- HTTP Listener (port 80) with 404 default response
- HTTPS Listener (port 443) with TLS 1.3 security policy
- SSL certificate attachment for HTTPS

## Inputs
- `tags` - Resource tags
- `public_subnets` - List of public subnet IDs for ALB placement
- `certificate_arn` - ARN of SSL certificate for HTTPS listener
- `security_groups` - List of security group IDs for ALB

## Outputs
- `alb_http_listener_arn` - HTTP listener ARN
- `alb_https_listener_arn` - HTTPS listener ARN
- `alb_dns_name` - ALB DNS name
- `alb_zone_id` - ALB Route 53 zone ID

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