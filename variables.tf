variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "location" {
  description = "datacenter location (nbg1, fsn1, hel1)"
  type        = string
  default     = "nbg1"
}

variable "server_type" {
  description = "Server type"
  type        = string
  default     = "cx22"
}

variable "image" {
  type    = string
  default = "debian-12"
}

variable "public_key_file" {
  type = string
}

variable "private_key_file" {
  type = string
}

variable "nixos_config" {
  type    = string
  default = "github:tcurdt/nixos-hetzner#base"
}

variable "disko_config" {
  type    = string
  default = "github:tcurdt/nixos-hetzner#base"
}
