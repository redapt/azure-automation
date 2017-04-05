env=${1:-dev}
terraform apply \
  -var-file="secret.tfvars" \
  -var-file="envs/${env}.tfvars"