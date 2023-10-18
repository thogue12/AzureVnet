

#create a randomly generating password
resource "random_password" "password" {
  length           = 16
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}



#create ms sql server and disable the public access
resource "azurerm_mssql_server" "mssql_server1" {
  name                          = var.mssql_server_name
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.database_username
  administrator_login_password  = random_password.password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

}

#create ms sql database
resource "azurerm_mssql_database" "mssql_database" {
  name      = var.mssql_database_name
  server_id = azurerm_mssql_server.mssql_server1.id
}

#create the private endpoint for the database/server
#associate the db with a specific subnet
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "db-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.database_subnet.id

  private_service_connection {
    name                           = "mssql_db_endpoint"
    private_connection_resource_id = azurerm_mssql_server.mssql_server1.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}



