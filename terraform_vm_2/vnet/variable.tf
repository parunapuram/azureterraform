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
variable "nsg_name" {}