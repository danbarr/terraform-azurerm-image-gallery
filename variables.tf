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
    name                    = string
    os_type                 = string
    offer                   = string
    sku                     = string
    app                     = string
    generation              = optional(string, "V2")
    trusted_launch_enabled  = optional(bool, true)
    confidential_vm_enabled = optional(bool)
  }))

  description = "VM image definitions to create in the gallery."
  default     = []

  validation {
    condition = alltrue([for o in var.image_definitions:
      anytrue([o.trusted_launch_enabled, o.confidential_vm_enabled]) && o.generation == "V2"
    ])
    error_message = "If trusted launch or confidential VM are enabled, `generation` must be `V2`."
  }

  validation {
    condition = alltrue([for o in var.image_definitions:
      ! alltrue([o.trusted_launch_enabled != null, o.confidential_vm_enabled != null])
    ])
    error_message = "Only one of `trusted_launch_enabled` or `confidential_vm_enabled` can be set."
  }
}
