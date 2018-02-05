# Declare variables
variable "do_token" {}

variable "project" {}

variable "region" {}

variable "image_slug" {
  type    = "string"
  default = "debian-9-x64"
}

variable "keys" {}

variable "private_key_path" {}

variable "ssh_fingerprint" {}

variable "public_key" {}

variable "ansible_user" {}
