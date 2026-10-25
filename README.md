# TerraformScripts

Terraform konfigurace pro můj Proxmox homelab (Infrastructure as Code).

## Obsah

| Adresář | Co dělá |
|---------|---------|
| [`NewVMProxmox/`](NewVMProxmox/) | Debian VM na Proxmoxu z cloud image, provisioning přes cloud-init (uživatel, SSH klíč, DHCP) |

## Stack

Terraform (>= 1.5), provider [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox), cloud-init, Proxmox VE.

## Použití

```bash
cd NewVMProxmox
terraform init && terraform plan && terraform apply
```

Detaily (nastavení tokenu, SSH agent, cloud image) jsou v [`NewVMProxmox/README.md`](NewVMProxmox/README.md).
Tajné hodnoty (`terraform.tfvars`) a `*.tfstate` jsou v `.gitignore` a nesmí se verzovat.

## Čemu jsem se naučil

Rozdělení provider/resource/secrets, práce s API tokenem a oprávněními na Proxmoxu, cloud-init, bezpečná práce se state souborem.
