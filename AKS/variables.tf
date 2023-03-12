variable "client_id" {
  description = "client ID"
}

variable "client_secret" {
  description = "client secret"
  sensitive = true
}

variable "resource_group" {
  description = "where to put cluster"
}