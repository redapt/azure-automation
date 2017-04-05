env=${1:-dev}
terraform plan \
  -var-file="secret.tfvars" \
  -var-file="envs/${env}.tfvars"