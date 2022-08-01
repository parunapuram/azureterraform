resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.rg_name
}
module "vnet" {
  source                  = "./vnet"
  location                = azurerm_resource_group.rg.location
  nsg_name                = var.nsg_name
  rg_name                 = var.rg_name
  subnet_address_prefixes = var.subnet_address_prefixes
  subnet_name             = var.subnet_name
  vnet_address_space      = var.vnet_address_space
  vnet_name               = var.vnet_name
}
module "vm" {
  source         = "./vm"
  admin_password = var.admin_password
  admin_username = var.admin_username
  location       = var.location
  nic_name       = var.nic_name
  public_ip_name = var.public_ip_name
  rg_name        = azurerm_resource_group.rg.name
  subnet_id      = module.vnet.subnet_id
  vm_name        = var.vm_name
  vm_size        = var.vm_size
  vm_count       = var.vm_count
}