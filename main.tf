provider "azurerm" {
  features {}
  subscription_id = "3c990c80-ea36-4c6c-afb2-da328349c3ac"
  client_id = "acd1e968-cf26-43c7-9ed8-fa583e44d29b"
  client_secret = "Q43el3S6Gjs-~6i~LnQbGUj3qafZhg7P-j"
  tenant_id = "4c0495a4-a1a3-4901-8cc1-9f37bab59629"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources-xya"
  location = "Central India"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["mynewdnster"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}
