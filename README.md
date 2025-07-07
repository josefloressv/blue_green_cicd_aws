# Blue/Green CI/CD with AWS

Infrastructure as Code for Blue/Green deployments using AWS ECS, ALB, and Terraform modules.

## Architecture
- **VPC**: Multi-AZ network with public/private subnets
- **ECS Cluster**: EC2-based with auto-scaling capacity provider
- **ALB**: Application Load Balancer with SSL termination
- **Modules**: Reusable Terraform components for network, compute, and load balancing

## Quick Start

### 1. Create S3 Backend
```bash
aws s3api create-bucket --bucket bgdemo-terraform-nonprod --region us-east-1 --acl private
aws s3api put-bucket-versioning --bucket bgdemo-terraform-nonprod --versioning-configuration Status=Enabled
```

### 2. Deploy Infrastructure
```bash
./deploy-infra.sh core nonprod plan
./deploy-infra.sh core nonprod apply
```

### 3. Cleanup
```bash
./deploy-infra.sh core nonprod destroy
```

## Structure
- `terraform/core/` - Main infrastructure configuration
- `terraform/modules/` - Reusable Terraform modules
- `deploy-infra.sh` - Deployment automation script
