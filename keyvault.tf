data "azurerm_client_config" "current" {}

# this resource block will create the azure key vault
resource "azurerm_key_vault" "key_vault" {
  name                     = "mssqlkeyvault19"
  location                 = "Eastus"
  resource_group_name      = azurerm_resource_group.resource_group.name
  purge_protection_enabled = false
  tenant_id                = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

# create the key vault access policy for the user
resource "azurerm_key_vault_access_policy" "terraform_user" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set", ]
  key_permissions = [
  "Get", "List", "Encrypt", "Decrypt", "Backup", "Create", "Delete", "Encrypt", "Get", "Import", "Purge",
   "Recover", "Restore", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", 
   "SetRotationPolicy"]
}




#create the secretes/keys that will be put into the key vault
#create the database username and put it into the key vault
resource "azurerm_key_vault_secret" "database_username" {
  name         = "db-username"
  value        = var.database_username
  key_vault_id = azurerm_key_vault.key_vault.id
}

#create the database password and put it into the key vault
resource "azurerm_key_vault_secret" "database_password" {
  name         = "db-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.key_vault.id
}


