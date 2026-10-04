variable "userpass" {
  type      = string
  sensitive = true
}

resource "proxmox_virtual_environment_vm" "debian_vm" {
  node_name = "pve"
  vm_id     = 110
  name      = "debian-vm"

  clone {
    vm_id = 112
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = "debian"
      password = var.userpass
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0m+rav2kyL9qrqYQ0qBNBuWvn3GB3Ql41ywZKYczG+KOEMoRj1OrRJcxRehdC29qfdREJdHJ7iIhSnIcNORCO1HWdDACXAaato5hVbHMDjjMRealQkoCm/7DFmWbLbzlp/GcGfGGvrOHSiN8fr6QjPWVYTB4aCqAMZeplOWfRTs9LIet1qm7+NpKJIezdpAMxKGmSePT6AN/NE5VLSIKYaVnxDzS/wkQiHGRZfemIIbTeQY++1aXpaXsV1eG/r6LVC4DEJ+OWrttEGzyJ2W3DzDwuD6tpY0of4zGtRiWzaFW6Qm9jtgYWOcg5DPEyYvSAWpXiSa3hzValufdUFQeiT21UwwCxipJ6yH5bbrUvvT2ACq3qqmciTLR6bNTkxyQvT6mPQYoXXEahPmoLuR7jy6Lu7CrT09N5TRbVHfdo2Jzrzkf/W/EIt4++5hxO06US8txhIvPJzf8rd3ORNSXnITF6kt4wRDBLWFDhGO4mBPNFLvN2h5EWr53s+kG0cRM= muj_mac"]
    }
  }

  started = true
}

output "vm_ip_address" {
  value       = proxmox_virtual_environment_vm.debian_vm.ipv4_addresses
  description = "IP adresy nově vytvořené virtuálky"
}
