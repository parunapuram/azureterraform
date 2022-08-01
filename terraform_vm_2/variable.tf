variable "location" {}
variable "rg_name" {}
variable "vnet_name" {}
variable "vnet_address_space" {
  type = list(string)
}
variable "subnet_name" {}
variable "subnet_address_prefixes" {
  type = list(string)
}
variable "public_ip_name" {}
variable "nic_name" {}
variable "vm_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {}
variable "nsg_name" {}
variable "vm_count" {}