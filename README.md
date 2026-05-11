# Terraform Homelab — Proxmox VE 8.4

Homelab DevOps journey — Terraform on Proxmox VE 8.4. Provisions Ubuntu VMs with static IPs, guest agent, cloud-init, and auto-generates Ansible inventory. Built with `bpg/proxmox` provider.

---

## Stack

- **Proxmox VE 8.4** — hypervisor
- **Terraform v1.15.2** — infrastructure provisioning
- **bpg/proxmox v0.46.4** — Proxmox provider
- **Ubuntu 22.04 LTS** — VM OS (cloud-init image)
- **Ansible** — configuration management (Week 4)

---

## Repository Structure

```
terraform/
├── week1/          # Foundation — first VM, core workflow
├── week2/          # Variables, outputs, for_each, static IPs
├── week3/          # Modules — reusable VM module
├── week4/          # Real project — Terraform + Ansible pipeline
└── .gitignore
```

---

## Prerequisites

### 1. Proxmox Host Setup

Before running any Terraform code, your Proxmox host needs:

**Ubuntu cloud-init template (VM ID 9000):**
```bash
# On Proxmox host as root
cd /tmp
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

qm create 9000 --name ubuntu-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000
rm jammy-server-cloudimg-amd64.img
```

**Install qemu-guest-agent in the template:**
```bash
# Untemplate, start, install agent, re-template
qm set 9000 --template 0
lvchange -p rw /dev/pve/base-9000-disk-0
qm start 9000
# In Proxmox console for VM 9000:
dhclient ens18
apt update && apt install qemu-guest-agent -y
shutdown -h now
# Back on Proxmox host:
qm template 9000
```

**Proxmox API Token:**

In Proxmox UI (Datacenter → Permissions):

1. Create role `TerraformRole` with VM and storage privileges
2. Create user `terraform@pve`
3. Create API token: `terraform@pve!terraform-token` with Privilege Separation **unchecked**
4. Assign `Administrator` role to both `terraform@pve` and `terraform@pve!terraform-token` at path `/` and `/sdn/zones`

### 2. Terraform Installation (on control node)

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
terraform version
```

---

## Configuration — terraform.tfvars (Required)

> **`terraform.tfvars` files are gitignored and NOT included in this repository.**
> You must create them manually in each week's directory before running Terraform.

### Week 1

Create `week1/terraform.tfvars`:
```hcl
pm_api_token = "terraform@pve!terraform-token=<your-token-secret>"
pm_password  = "<your-proxmox-root-password>"
```

### Week 2

Create `week2/terraform.tfvars`:
```hcl
node_name    = "hassan"          # your Proxmox node name
pm_api_token = "terraform@pve!terraform-token=<your-token-secret>"
pm_password  = "<your-proxmox-root-password>"

vms = {
  slavethree = {
    vm_id    = 103
    name     = "slavethree"
    username = "slavethree"
    password = "<vm-password>"
    ip       = "192.168.100.18/24"   # adjust to your network
  }
  slavefour = {
    vm_id    = 104
    name     = "slavefour"
    username = "slavefour"
    password = "<vm-password>"
    ip       = "192.168.100.19/24"
  }
}
```

### Week 3 & Week 4

Create `week3/terraform.tfvars` and `week4/terraform.tfvars`:
```hcl
node_name    = "hassan"          # your Proxmox node name
gateway      = "192.168.100.1"   # your network gateway
ssh_key      = "ssh-ed25519 AAAA...  your-key-comment"
pm_api_token = "terraform@pve!terraform-token=<your-token-secret>"
pm_password  = "<your-proxmox-root-password>"
```

---

## Running the Project

### Any week (1-3)

```bash
cd week<N>
terraform init
terraform plan
terraform apply
terraform destroy
```

### Week 4 — Full Terraform + Ansible Pipeline

```bash
cd week4

# Step 1 — Provision VMs and generate inventory
terraform init
terraform plan
terraform apply
# inventory.ini is auto-generated after apply

# Step 2 — Verify Ansible connectivity
ansible all -i inventory.ini -m ping

# Step 3 — Run playbook
ansible-playbook -i inventory.ini install_nginx.yml

# Step 4 — Verify nginx
ansible slavenodes -i inventory.ini -m shell -a "curl -s http://127.0.0.1"

# Step 5 — Tear down
terraform destroy
```

---

## What Each Week Builds

| Week | Concepts | Result |
|------|----------|--------|
| Week 1 | Provider setup, first VM, core workflow | Single VM created and destroyed |
| Week 2 | Variables, `for_each`, outputs, static IPs | 2 VMs from one resource block, IPs printed automatically |
| Week 3 | Modules — reusable VM component | 2 VMs from a reusable module, logic hidden from caller |
| Week 4 | `local_file`, `templatefile()`, `depends_on` | 2 VMs + auto-generated Ansible inventory + nginx configured |

---

## Important Notes

- `terraform.tfvars` — **never commit this file**, it contains credentials
- `terraform.tfstate` — **never manually edit this file**, it is Terraform's source of truth
- `stop_on_destroy = true` — always include this for Proxmox VMs or `terraform destroy` will hang
- `agent { enabled = true }` — requires `qemu-guest-agent` installed in the template
- `ip_config { ipv4 { address = "dhcp" } }` — required for cloud-init to bring up the network interface; without it the network stays DOWN

---

## Network Configuration

This project assumes:
- Proxmox host: `192.168.100.9`
- Gateway: `192.168.100.1`
- VM IPs: `192.168.100.18` and `192.168.100.19`

Adjust these values in `terraform.tfvars` to match your network.

---

## Author

**Mohammed Hassan**
Junior DevOps Engineer, Dhaka, Bangladesh
Homelab: Proxmox VE 8.4 with Ubuntu 22.04 VMs
