
#create storage account the house the database

resource "azurerm_storage_account" "stoage_account" {
  name                     = "timsnewstgsccnt2705"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


#create a randomly generating password
resource "random_password" "password" {
  length = 16
  lower  = false
}


resource "azurerm_mssql_server" "mssql_server" {
  name                         = "mssqlserver"
  resource_group_name          = azurerm_resource_group.resource_group.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "mssqladmin"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

}


resource "azurerm_mssql_database" "mssql_database" {
  name           = "tims-mssql-db"
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true


}

# Create a secret in Azure Key Vault for the database password
resource "azurerm_key_vault_secret" "mysql_password_secret" {
  name         = "MySQLPassword"
  value        = random_password.password.result
  key_vault_id  = azurerm_key_vault.key_vault.id

}


data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = "mssqlkeyvault"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.resource_group.name
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

}
