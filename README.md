# azure-automation

## Setup
Create `secret.tfvars`

```
# Windows Azure Credentials
az_subscription_id = "00000000-0000-0000-0000-000000000000"
az_client_id       = "00000000-0000-0000-0000-000000000000"
az_client_secret   = "00000000-0000-0000-0000-000000000000"
az_tenant_id       = "00000000-0000-0000-0000-000000000000"
```

## Configure Remote State (Azure)
You should setup an Azure storage account, and use the appropriate values.

```
terraform remote config \
	-backend=azure \
	-backend-config='storage_account_name=redapt' \
	-backend-config='container_name=terraform-state' \
	-backend-config='key=terraform.tfstate' \
	-backend-config="access_key=${AZ_STATE_ACCESS_KEY}"
```

## Running
There are a few shell scripts included to simplify running terraform. 
- `bash plan.sh` will run a scoped terraform plan operation 
- `bash apply.sh` will run  a scoped terraform apply operation