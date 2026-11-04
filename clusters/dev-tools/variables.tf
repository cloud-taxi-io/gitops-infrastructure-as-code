variable "hcloud_token" {
  description = "Hetzner Cloud API token (read/write). Pass via TF_VAR_hcloud_token, never commit it."
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Prefix used for all resources."
  type        = string
  default     = "dev-tools"
}

variable "server_count" {
  description = "Number of Ubuntu VMs."
  type        = number
  default     = 3
}

variable "server_type" {
  description = "Hetzner server type."
  type        = string
  default     = "cx23"
}

variable "image" {
  description = "OS image."
  type        = string
  default     = "ubuntu-24.04"
}

variable "location" {
  description = "Hetzner location (nbg1, fsn1, hel1, ...)."
  type        = string
  default     = "nbg1"
}

variable "ssh_public_key" {
  description = "SSH public key content installed on the VMs."
  type        = string
}

variable "admin_cidrs" {
  description = "CIDRs allowed to reach SSH (22) and the Kubernetes API (6443). Restrict to your own IPs."
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "network_cidr" {
  description = "Private network range."
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "Private subnet range."
  type        = string
  default     = "10.10.1.0/24"
}
