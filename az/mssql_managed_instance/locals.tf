locals {
  private_fqdn_split = split(".", azurerm_mssql_managed_instance.this.fqdn)
  public_fqdn        = format("%s.public.%s", local.private_fqdn_split[0], join(".", slice(local.private_fqdn_split, 1, 5)))
}