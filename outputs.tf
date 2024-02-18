output "image_gallery_id" {
  description = "ID of the created image gallery."
  value       = azurerm_shared_image_gallery.packer.id
}

output "image_gallery_unique_name" {
  description = "Unique name of the created image gallery."
  value       = azurerm_shared_image_gallery.packer.unique_name
}

output "shared_images" {
  description = "Shared image definitions."
  value = {
    for image in azurerm_shared_image.packer : image.name => image.id
  }
}
