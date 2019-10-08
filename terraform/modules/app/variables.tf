variable private_key_path {
  description = "Path to the public key used to connect to instance"
}
variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable mach_type {
  description = "Machine type"
  default = "f1-micro"
}
variable "database_url" {
  description = "database_url for reddit app"
  default     = "127.0.0.1:27017"
}