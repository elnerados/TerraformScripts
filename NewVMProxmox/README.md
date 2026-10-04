# NewVMProxmox — Terraform konfigurace pro Debian VM

## Struktura souborů

- **provider.tf** — "s kým mluvím" (adresa Proxmoxu, přihlašovací údaje, SSH nastavení)
- **vm.tf** — "co chci vytvořit" (definice VM — CPU, RAM, disk, síť, cloud-init)
- **terraform.tfvars** — "tajné hodnoty" (tokeny, hesla — nikdy do gitu!)
- **terraform.tfstate** — "co jsem vytvořil" (Terraform si pamatuje, co na Proxmoxu existuje, aby věděl co přidat/změnit/smazat)

## Jak to funguje

### Provider (provider.tf)

Terraform komunikuje s Proxmoxem dvěma způsoby:

1. **API** (port 8006) — pro vytváření a správu VM. Používá `api_token`.
2. **SSH** (port 22) — pro nahrávání disků na server. Proto je v provideru blok `ssh` s uživatelem a `agent = true` (= použij klíč z ssh-agenta).

### Disk image (vm.tf)

Aby VM měla nainstalovaný systém, potřebuje **cloud image** — hotový obraz disku s předinstalovaným OS. Způsoby, jak ho dostat na Proxmox:

- **Automaticky přes Terraform** (`proxmox_virtual_environment_download_file`) — vyžaduje oprávnění `Datastore.AllocateTemplate` na API tokenu
- **Ručně** — stáhnout image přes Proxmox webové rozhraní a odkázat na něj přes `file_id = "local:iso/název-souboru.img"`

### Cloud-init (blok `initialization` ve vm.tf)

Při prvním startu VM automaticky:
- Vytvoří uživatele (např. `debian`)
- Nastaví heslo
- Přidá SSH klíč pro přihlášení bez hesla
- Nakonfiguruje síť (DHCP = dostane IP automaticky)

## Typický workflow

```bash
terraform init      # stáhne provider plugin (stačí jednou)
terraform plan      # ukáže co se změní (nanečisto, nic neprovede)
terraform apply     # provede změny na Proxmoxu
terraform destroy   # smaže vše co Terraform vytvořil
```

## Před spuštěním

1. Nahraj SSH klíč do agenta: `ssh-add ~/.ssh/id_rsa`
2. Ověř, že Debian cloud image je nahraný na Proxmoxu v `local` storage pod ISO Images
3. Zkontroluj, že `terraform.tfvars` obsahuje správný API token a URL

## Bezpečnost

- **terraform.tfvars** a **terraform.tfstate** nikdy necommitovat do gitu (obsahují tokeny a hesla)
- Přidej je do `.gitignore`
