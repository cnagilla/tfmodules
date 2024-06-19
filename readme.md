# iac

- az ad sp create-for-rbac --name "myServicePrincipal" --role Contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

export ARM_CLIENT_ID=YOUR_APP_ID\
export ARM_CLIENT_SECRET=YOUR_CLIENT_SECRET\
export ARM_SUBSCRIPTION_ID=YOUR_SUBSCRIPTION_ID\
export ARM_TENANT_ID=YOUR_TENANT_ID\


terraform init\
terraform plan\
terraform apply
