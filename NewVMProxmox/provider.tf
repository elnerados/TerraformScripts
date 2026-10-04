terraform {
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60.0"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

provider "proxmox" {
    endpoint  = var.proxmox_api_url
    api_token = var.proxmox_api_token
    insecure  = true

    ssh {
      agent = true
      username = "gemini"

    }
}

