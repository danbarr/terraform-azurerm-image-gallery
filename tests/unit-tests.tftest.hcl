variables {
  resource_group_name = "packer-images-test"
  image_gallery_name  = "packer_images_test"
  publisher           = "HashiCafe-test"

  image_definitions = [
    {
      name    = "ubuntu22-base"
      os_type = "Linux"
      offer   = "ubuntu22-base"
      sku     = "22_04-lts"
      app     = "test"
    }
  ]
}

provider "azurerm" {
  features {}
}

override_data {
  target = data.azurerm_resource_group.packer
  values = {
    name     = "packer-images-test"
    location = "CentralUS"
  }
}

run "basic_plan" {
  command = plan

  assert {
    condition     = azurerm_shared_image_gallery.packer.name == "packer_images_test"
    error_message = "Gallery name does not match expected."
  }

  assert {
    condition     = azurerm_shared_image.packer["ubuntu22-base"].trusted_launch_supported == true
    error_message = "Default image definition should have `trusted_launch_supported = true`."
  }
}
