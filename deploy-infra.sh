#! /usr/bin/env bash
set -o nounset -o pipefail -o errexit;

# Source the .env file
cd terraform/
. .env

# Validate arguments: $1 folder, $2 environment, $3 action
if [ -z "$1" ]; then
  echo "Error: Folder argument is missing. Use ./deploy-infra.sh core nonprod plan"
  exit 1
elif [ -z "$2" ]; then
  echo "Error: Environment argument is missing. Use ./deploy-infra.sh core nonprod plan"
  exit 1
elif [ -z "$3" ]; then
  echo "Error: Terraform Action argument is missing. Use ./deploy-infra.sh core nonprod plan"
  exit 1
elif [ ! -d "$1" ]; then
  echo "Error: $1 folder doesn't exists!"
  exit 1
elif ! [[ "$2" =~ ^($VALID_ENVIRONNMENTS)$ ]]; then
  echo "Error: Invalid environment \"$2\" . Must be $VALID_ENVIRONNMENTS."
  exit 1
elif ! [[ "$3" =~ ^($VALID_ACTIONS)$ ]]; then
  echo "Error: Invalid Terraform action \"$2\" . Must be $VALID_ACTIONS."
  exit 1
fi

# Define Dynamic environment variables
INFRA_DIR=$1
ENV=$2
TFACTION=$3
VAR_FILE="config/${ENV}.tfvars"
TFBUCKET="${TF_VAR_platform}-terraform-${ENV}"
TFKEY="${INFRA_DIR}.tfstate"

export TF_VAR_environment=${ENV}
export AWS_REGION=$TF_VAR_aws_region

# Change to the infrastructure directory
cd "$INFRA_DIR"

# Validate Terraform variables file
if [ ! -f "$VAR_FILE" ]; then
  echo "Error: $VAR_FILE file doesn't exists!"
  exit 1
fi

# Cleanup function to remove Terraform state files
cleanup() {
  # clear TF state local, to avoid fail when change the environment
  rm -rf .terraform/terraform.tfstate
}

trap cleanup EXIT ERR


# ----------------------------------------------------------------
# Install Terraform using tfenv
# ----------------------------------------------------------------

# Only run Terraform version check and installation if not running in CI (CircleCI)
if [ -z "${CIRCLECI:-}" ]; then
  # Check if current Terraform version matches required version
  CURRENT_TF_VERSION=$(terraform version -json | jq -r '.terraform_version')
  if [ "$CURRENT_TF_VERSION" != "$TF_VERSION" ]; then
    # Install Terraform using tfenv
    echo "Installing Terraform $TF_VERSION..."
    tfenv use "$TF_VERSION"
  fi
fi

# ----------------------------------------------------------------
# Terraform commands
# ----------------------------------------------------------------

# Format
echo "Terraform format..."
terraform fmt $VAR_FILE
terraform fmt

# Initialize
echo "Initializing Terraform..."
terraform init \
  -input=false \
  -backend-config="bucket=$TFBUCKET" \
  -backend-config="key=$TFKEY" \
  -backend-config="region=$AWS_REGION"

# Validate
echo "Terraform validate..."
terraform validate

# Imports goes here
# -------------------------------------------------------------------------------
# terraform state rm [tfstat elemental]
# terraform import -var-file="$VAR_FILE" [tfstat elemental] [aws arn/id]
#
# -------------------------------------------------------------------------------

# Plan
echo "Running Terraform plan..."
terraform plan \
  -input=false \
  -var-file="$VAR_FILE" \
  -out="$ENV.tfplan"

terraform output

# Apply
if [ "_${TFACTION}" == "_apply" ]; then
  echo "Running Terraform apply..."
  terraform apply \
    -auto-approve=true \
    "$ENV.tfplan"
fi

# Destroy
if [ "_${TFACTION}" == "_destroy" ]; then
  echo "Running Terraform destroy..."
  terraform destroy \
    -input=false \
    -var-file="$VAR_FILE"
fi
