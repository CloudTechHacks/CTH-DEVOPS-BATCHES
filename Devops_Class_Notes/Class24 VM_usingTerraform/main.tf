resource "azurerm_public_ip" "pip" {
  name                = "cth-pip"
  resource_group_name = "cth-rg1"
  location            = "centralindia"
  allocation_method   = "Static"
  
  }
resource "azurerm_network_interface" "nic" {
  name                = "cth-nic"
  location            = "centralindia"
  resource_group_name = "cth-rg1"

  ip_configuration {
    name                          = "cth-ip-config"
    subnet_id                     ="/subscriptions/043c7cd8-9a4a-4c40-a724-72ad505082f3/resourceGroups/cth-rg1/providers/Microsoft.Network/virtualNetworks/cth-vnet01/subnets/cth-frontend-subnet01"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id=azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "cth-web01"
  resource_group_name = "cth-rg1"
  location            = "centralindia"
  size                = "Standard_F2"
  admin_username      = "cthadmin01"
  admin_password = "Cthadmin01"
  disable_password_authentication=false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}