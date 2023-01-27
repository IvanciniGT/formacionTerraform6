terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_string" "nombre_grupo_recursos" {
  count            = var.nombre_grupo_recursos == null ? 1 : 0
  length           = 5
  special          = false
}

// Grupo de recursos en el que crear mis objetos
resource   "azurerm_resource_group"   "grupo_recursos"   { 
    count      =   var.nombre_grupo_recursos == null ? 1 : 0
    name       =   "grupo-recursos-${random_string.nombre_grupo_recursos[0].result}" 
    location   =   "northeurope" 
} 

data "azurerm_resource_group" "grupo_existente" {
  name = var.nombre_grupo_recursos==null ? azurerm_resource_group.grupo_recursos[0].name : var.nombre_grupo_recursos
}

// Red
 resource   "azurerm_virtual_network"   "red_virtual"   { 
   name                  =   "red-virtual-ivan" 
   address_space         =   [ "10.0.0.0/16" ] 
   location              =   data.azurerm_resource_group.grupo_existente.location
   resource_group_name   =   data.azurerm_resource_group.grupo_existente.name
 } 
 
 // Subred dentro de esta red
 resource   "azurerm_subnet"   "subred"   { 
   name   =   "subred-ivan" 
   resource_group_name   =   data.azurerm_resource_group.grupo_existente.name
   virtual_network_name   =  azurerm_virtual_network.red_virtual.name 
   address_prefixes       =  [ "10.0.2.0/24" ]
 } 
 
 // IP Publica 
 resource   "azurerm_public_ip"   "ip_publica"   { 
   name                 =   "ip_publica_ivan" 
   location              =   data.azurerm_resource_group.grupo_existente.location
   resource_group_name   =   data.azurerm_resource_group.grupo_existente.name
   allocation_method    =   "Dynamic" 
 } 
 
 // Interfaz de red

 resource   "azurerm_network_interface"   "interfaz_red"   { 
   name                  =   "interfaz_red_ivan" 
   location              =   data.azurerm_resource_group.grupo_existente.location
   resource_group_name   =   data.azurerm_resource_group.grupo_existente.name

   ip_configuration   { 
     name                            =   "configuracion-ip-ivan" 
     subnet_id                       =   azurerm_subnet.subred.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id            =   azurerm_public_ip.ip_publica.id 
   } 
 }  
 
// Instancia / Servidor

resource   "azurerm_windows_virtual_machine"   "servidor"   { 
   name                    =   "servidor-ivan"   
   location                =   data.azurerm_resource_group.grupo_existente.location
   resource_group_name     =   data.azurerm_resource_group.grupo_existente.name
   network_interface_ids   =   [ azurerm_network_interface.interfaz_red.id ] 
   size                    =   "Standard_F2" 
   admin_username          =   "ivanciniGT" 
   admin_password          =   "Pa$$w0rd" 

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 

   os_disk   { 
     caching                =   "ReadWrite" 
     storage_account_type   =   "Standard_LRS" 
   } 
}