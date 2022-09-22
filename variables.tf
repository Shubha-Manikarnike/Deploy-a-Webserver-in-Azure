variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacityazdevops"
}

variable "resourcegroup" {
  description = "Enter name of the resource group "
  default = "MyResourceGroups"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US" 
}

variable "username"{
  description = "Username"
  default = "shubha.vasudev@gmail.com"
}

variable "password"{
  description= "Password"
  default = "M@@ly@d@16"
}

variable "packerImageId"{
  description = "Enter the Image created via packer"
  default = "/subscriptions/25fe1a94-31b3-432e-8734-e5b6f1d4deab/resourceGroups/MyResourceGroups/providers/Microsoft.Compute/images/myPackerImage"
}

variable "countofvm"{
  description = "How many virtual machines do you want to create ?"
  default = "2"
}