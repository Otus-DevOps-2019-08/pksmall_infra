variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-db-base"
}
variable mach_type {
  description = "Machine type"
  default = "f1-micro"
}
variable "enable_provision" {
  description = "enable app and db provision"
  type        = bool
  default     = false
}
