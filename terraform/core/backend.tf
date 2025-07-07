terraform {
  backend "s3" {
    # Dynamic configuration in deploy-infra.sh script
    encrypt = true
  }
}
