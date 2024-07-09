terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.43.0"
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

  name                = each.value.name
  gallery_name        = azurerm_shared_image_gallery.packer.name
  resource_group_name = data.azurerm_resource_group.packer.name
  location            = data.azurerm_resource_group.packer.location
  os_type             = each.value.os_type
  hyper_v_generation  = each.value.generation

  # Only one of these can have a value
  trusted_launch_supported  = each.value.security_type == "TrustedLaunchSupported" ? true : null
  trusted_launch_enabled    = each.value.security_type == "TrustedLaunch" ? true : null
  confidential_vm_supported = each.value.security_type == "ConfidentialVMSupported" ? true : null
  confidential_vm_enabled   = each.value.security_type == "ConfidentialVM" ? true : null

  identifier {
    publisher = var.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }

  tags = {
    App = each.value.app
  }
}
