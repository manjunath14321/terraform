variable "key" {
  default = "ssh_key"
}

variable "rg_name" {
  default = "terraform_rg"
}

variable "location" {
  default = "Central India"
}
variable "address_space" {
  default = ["10.1.0.0/16"]
  type    = list(string)
}

variable "vnet_name" {
  default = "terraform_vnet1"
}
variable "subnet_space" {
  default = ["10.1.0.0/24", "10.1.10.0/24"]
  type    = list(string)
}

variable "subnet_name" {
  default = "terraform_snet"
}

variable "sku" {
  default = "22.04-lts"
}
variable "vm_name" {
  default = "vm"
}
variable "admin" {
  default = "azureuser"
}
variable "size" {
  default = "Standard_B1s"
}

variable "user" {
  default = "azureuser"
}

variable "nic_name" {
  default = "nic"
}

variable "nsg" {
  default = "nsg"
}

variable "pip_name" {
  default = "pip"
}

variable "ip_name" {
  default = "ip"
}
