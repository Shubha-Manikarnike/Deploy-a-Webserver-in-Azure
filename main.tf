# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Create or Update a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resourcegroup
  location = var.location
}

# Create a availabity set for virtual machines
resource "azurerm_availability_set" "main" {
  name                        = "${var.prefix}-aset"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  platform_fault_domain_count = 2

  tags = {
    project = "Azuredevops"
  }
}

# Create a network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowVnetInBound"
    description                = "Allow access to other VMs on the subnet"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyInternetInBound"
    description                = "Deny all inbound traffic outside of the vnet from the Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    project = "Azuredevops"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-publicIp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    project = "Azuredevops"
  }
}

# create a load balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {
    project = "Azuredevops"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  
  loadbalancer_id     = azurerm_lb.main.id
  name                = "BackEndAddressPool"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project = "Azuredevops"
  }
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "main" {
  count = var.countofvm

  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project = "Azuredevops"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {

  count = var.countofvm
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "testConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
  count = var.countofvm
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id
  ]
  availability_set_id = azurerm_availability_set.main.id
  source_image_id     = var.packerImageId


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    project      = "Azuredevops",
    topic        = "WebserverDeployment"
  }
}

# create managed disk for virtual machine
resource "azurerm_managed_disk" "main" {
  name                 = "${var.prefix}-md"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    project = "Azuredevops"
  }
}