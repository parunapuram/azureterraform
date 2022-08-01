resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "${var.public_ip_name}-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "nic" {
  count = var.vm_count

  name                = "${var.nic_name}-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    #    private_ip_address            = "10.0.0.5"
    public_ip_address_id = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count = var.vm_count

  name                = "${var.vm_name}${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = var.vm_name
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
    name                 = "${var.vm_name}-osdisk-${count.index}"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
}
resource "azurerm_managed_disk" "data_disk" {
  count                = var.vm_count
  name                 = "${var.vm_name}-datadisk-${count.index}"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}