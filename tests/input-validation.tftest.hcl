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

mock_provider "azurerm" {}

run "default_values" {
  command = plan
}

run "gen1_vm" {
  command = plan

  variables {
    image_definitions = [
      {
        name          = "ubuntu22-base"
        os_type       = "Linux"
        offer         = "ubuntu22-base"
        sku           = "22_04-lts"
        app           = "test"
        generation    = "V1"
        security_type = "Standard"
      },
    ]
  }
}

run "invalid_gallery_name" {
  command = plan

  variables {
    image_gallery_name = "invalid-name"
  }

  expect_failures = [var.image_gallery_name]
}

run "gallery_name_length" {
  command = plan

  variables {
    image_gallery_name = "gallery_name_too_long_lorem_ipsum_dolor_sit_amet_consectetur_adipiscing_elit_sed_do"
  }

  expect_failures = [var.image_gallery_name]
}

run "invalid_generation" {
  command = plan

  variables {
    image_definitions = [
      {
        name    = "ubuntu22-base"
        os_type = "Linux"
        offer   = "ubuntu22-base"
        sku     = "22_04-lts"
        app     = "none"

        # Only the Standard security type is compatible with Gen 1 VMs
        generation    = "V1"
        security_type = "TrustedLaunchSupported"
      },
    ]
  }

  expect_failures = [var.image_definitions]
}

run "invalid_security_option" {
  command = plan

  variables {
    image_definitions = [
      {
        name          = "ubuntu22-base"
        os_type       = "Linux"
        offer         = "ubuntu22-base"
        sku           = "22_04-lts"
        app           = "none"
        generation    = "V2"
        security_type = "BadValue"
      },
    ]
  }

  expect_failures = [var.image_definitions]
}
