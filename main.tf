terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.0"
    }
  }
}

data "azurerm_resource_group" "packer" {
  name = var.resource_group_name
}

resource "azurerm_shared_image_gallery" "packer" {
  name                = var.image_gallery_name
  resource_group_name = data.azurerm_resource_group.packer.name
  location            = data.azurerm_resource_group.packer.location
  description         = var.image_gallery_description

  tags = {
    App       = "packer"
    ManagedBy = "terraform"
  }
}

resource "azurerm_shared_image" "packer" {
  for_each = { for image in var.image_definitions : image.name => image }

  name                    = each.value.name
  gallery_name            = azurerm_shared_image_gallery.packer.name
  resource_group_name     = data.azurerm_resource_group.packer.name
  location                = data.azurerm_resource_group.packer.location
  os_type                 = each.value.os_type
  hyper_v_generation      = each.value.generation
  trusted_launch_enabled  = each.value.trusted_launch_enabled
  confidential_vm_enabled = each.value.confidential_vm_enabled

  identifier {
    publisher = var.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }

  tags = {
    App = each.value.app
  }
}
