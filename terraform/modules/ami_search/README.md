# AMI Search Module

Searches for the most recent Amazon Machine Image (AMI) based on specified platform, architecture, and date criteria. Supports both Linux and Windows ECS-optimized AMIs.

## Resources
- Data source for AWS AMI search with filters for platform, architecture, and date

## Inputs
- `image_platform` - Operating system platform ("linux" or "windows")
- `image_architecture` - CPU architecture ("arm64" or "amd64") 
- `image_date` - AMI date in YYYY-MM format

## Outputs
- `id` - AMI ID
- `name` - AMI name
- `creation_date` - AMI creation date
- `deprecation_time` - AMI deprecation time
- `platform_details` - Platform details
- `architecture` - AMI architecture
- `image_type` - AMI image type

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