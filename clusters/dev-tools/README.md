# clusters/dev-tools

Terraform for 3 Ubuntu 24.04 VMs on Hetzner Cloud (1 master + 2 workers), with a private network and a firewall.

## Usage
```bash
export TF_VAR_hcloud_token=<hetzner-api-token>
cp terraform.tfvars.example terraform.tfvars   # edit ssh key + admin_cidrs
terraform init
terraform plan
terraform apply
```

Notes:
- Restrict `admin_cidrs` to your own IPs; the default is open.
- State is local. Move it to a remote backend before team use.
- Never commit `terraform.tfvars` or state files.
