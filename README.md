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

## Running
There are a few shell scripts included to simplify running terraform. 
- `bash plan.sh` will run a scoped terraform plan operation 
- `bash apply.sh` will run  a scoped terraform apply operation