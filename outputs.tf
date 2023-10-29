output "image_gallery_id" {
  description = "ID of the created image gallery."
  value       = azurerm_shared_image_gallery.packer.id
}

output "image_gallery_unique_name" {
  description = "Unique name of the created image gallery."
  value       = azurerm_shared_image_gallery.packer.unique_name
}

output "shared_image_names" {
  description = "Names of the shared image definitions."
  value       = values(azurerm_shared_image.packer)[*].name
}

output "shared_image_ids" {
  description = "IDs of the shared image definitions."
  value       = values(azurerm_shared_image.packer)[*].id
}
