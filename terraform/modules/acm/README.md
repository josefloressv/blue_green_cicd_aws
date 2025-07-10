# AWS Certificate Manager (ACM) Module

Creates an SSL/TLS certificate using AWS Certificate Manager with DNS validation. This module provisions a certificate for secure HTTPS connections and supports Subject Alternative Names (SANs) for multiple domain validation.

## Resources
- AWS ACM Certificate with DNS validation
- Support for Subject Alternative Names (SANs)
- Lifecycle management with create_before_destroy

## Inputs
- `tags` - Resource tags (map of strings)
- `domain_name` - Primary domain name for the certificate (string)
- `subject_alternative_names` - List of additional domain names to include in the certificate (list of strings, optional)

## Outputs
- `certificate_id` - The ARN of the certificate

## Usage Example

```hcl
module "acm_certificate" {
  source = "./modules/acm"

  domain_name = "example.com"
  subject_alternative_names = [
    "*.example.com",
    "api.example.com"
  ]

  tags = {
    Platform    = "myapp"
    Environment = "prod"
    Module      = "acm"
  }
}
```

## Important Notes

- This module uses DNS validation method, which requires you to create DNS records to validate domain ownership
- The certificate has `create_before_destroy` lifecycle rule to prevent service interruption during updates
- After applying, you'll need to add the DNS validation records to your DNS provider
- The certificate will be in "Pending validation" state until DNS validation is complete

## Requirements

- AWS Provider ~> 5.68.0
- Terraform >= 1.0

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