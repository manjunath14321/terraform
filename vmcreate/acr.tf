data "azurerm_resource_group" "terraform_rg" {
  name = "terraform_rg"
}

resource "azurerm_container_registry" "manjunath" {
  name                = "terraformregmanju"
  resource_group_name = data.azurerm_resource_group.terraform_rg.name
  location            = data.azurerm_resource_group.terraform_rg.location
  sku                 = "Premium"
  admin_enabled       = true
}

output "adminpwd" {
  value = azurerm_container_registry.manjunath.admin_password
  sensitive = true
}

resource "azurerm_container_registry_token" "token" {
  name                    = "manjunath"
  container_registry_name = azurerm_container_registry.manjunath.name
  resource_group_name     = data.azurerm_resource_group.terraform_rg.name
  scope_map_id            = data.azurerm_container_registry_scope_map.scope.id
}

data "azurerm_container_registry_scope_map" "scope" {
  name                    = "_repositories_pull"
  resource_group_name     = data.azurerm_resource_group.terraform_rg.name
  container_registry_name = azurerm_container_registry.manjunath.name
}

resource "azurerm_container_registry_token_password" "pwd" {
  container_registry_token_id = azurerm_container_registry_token.token.id

  password1 {
    expiry = "2024-11-24T17:57:36+08:00"
  }
}
