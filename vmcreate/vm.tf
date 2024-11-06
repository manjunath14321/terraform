resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.rg_name
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "sbnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.subnet_space
}


resource "azurerm_ssh_public_key" "ssh1" {
  name                = var.key
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  ip_configuration {
    name                          = var.ip_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
    subnet_id                     = azurerm_subnet.sbnet.id
  }
}
resource "azurerm_network_interface" "windowsnic" {
  name                = "windows_nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  ip_configuration {
    name                          = var.ip_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_windows.id
    subnet_id                     = azurerm_subnet.sbnet.id
  }
}
resource "azurerm_public_ip" "publicip_windows" {
  name                = "publicip-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_linux_virtual_machine" "lvm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  admin_username        = var.admin
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.size

  admin_ssh_key {
    public_key = file("~/.ssh/id_rsa.pub")
    username   = var.user
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "windowsvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.windowsnic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk22"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mywinvm"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {

  }

  tags = {
    environment = "staging"
  }
}


resource "azurerm_network_security_group" "networksecuritygroup" {
  name                = var.nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "sshport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgasoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.networksecuritygroup.id
}

