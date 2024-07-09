variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group where the gallery will be created."
}

variable "image_gallery_name" {
  type        = string
  description = "Name for the shared image gallery."
  default     = "packer_images"

  validation {
    condition     = length(var.image_gallery_name) >= 1 && length(var.image_gallery_name) <= 80
    error_message = "Image gallery names must be between 1 and 80 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\.]+$", var.image_gallery_name))
    error_message = "Image gallery names can only contain letters, numbers, underscores, and periods."
  }
}

variable "image_gallery_description" {
  type        = string
  description = "Description for the shared image gallery."
  default     = "Shared images built by Packer."
}

variable "publisher" {
  type        = string
  description = "Publisher name to use on image definitions."
}

variable "image_definitions" {
  type = list(object({
    name          = string
    os_type       = string
    offer         = string
    sku           = string
    app           = string
    generation    = optional(string, "V2")
    security_type = optional(string, "TrustedLaunchSupported")
  }))

  description = "VM image definitions to create in the gallery."
  default     = []

  validation {
    condition = alltrue([for o in var.image_definitions :
      contains(["Windows", "Linux"], o.os_type)
    ])
    error_message = "Valid values for `os_type` are `Windows` and `Linux`."
  }

  validation {
    condition = alltrue([for o in var.image_definitions :
      contains(["V1", "V2"], o.generation)
    ])
    error_message = "Valid values for `generation` are `V1` and `V2`."
  }

  validation {
    condition = alltrue([for o in var.image_definitions :
      o.generation == "V1" ? o.security_type == "Standard" : true
    ])
    error_message = "Only the `Standard` security type is supported for Gen 1 VMs."
  }

  validation {
    condition = alltrue([for o in var.image_definitions :
      contains(["Standard", "TrustedLaunchSupported", "TrustedLaunch", "ConfidentialVMSupported", "ConfidentialVM"], o.security_type)
    ])
    error_message = "Valid values for `security_type` are: `Standard`, `TrustedLaunchSupported` (default), `TrustedLaunch`, `ConfidentialVMSupported`, `ConfidentialVM`."
  }
}
