variable project {
  description = "Project Name"
}
variable name {
  description = "App Name"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west3"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "europe-west3-c"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable db_disk_image {
  description = "DB Disk image for reddit app"
  default = "reddit-db-base"
}
