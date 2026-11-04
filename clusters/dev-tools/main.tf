locals {
  labels = {
    cluster    = var.cluster_name
    managed-by = "terraform"
  }
}

resource "hcloud_ssh_key" "this" {
  name       = "${var.cluster_name}-key"
  public_key = var.ssh_public_key
  labels     = local.labels
}

resource "hcloud_network" "this" {
  name     = "${var.cluster_name}-net"
  ip_range = var.network_cidr
  labels   = local.labels
}

resource "hcloud_network_subnet" "this" {
  network_id   = hcloud_network.this.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.subnet_cidr
}

resource "hcloud_firewall" "this" {
  name   = "${var.cluster_name}-fw"
  labels = local.labels

  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.admin_cidrs
  }

  rule {
    description = "Kubernetes API"
    direction   = "in"
    protocol    = "tcp"
    port        = "6443"
    source_ips  = var.admin_cidrs
  }

  rule {
    description = "HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "node" {
  count = var.server_count

  name         = "${var.cluster_name}-${count.index == 0 ? "master" : "node-${count.index}"}"
  server_type  = var.server_type
  image        = var.image
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.this.id]
  firewall_ids = [hcloud_firewall.this.id]

  labels = merge(local.labels, {
    role = count.index == 0 ? "master" : "worker"
  })

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.this.id
    ip         = cidrhost(var.subnet_cidr, count.index + 10)
  }

  depends_on = [hcloud_network_subnet.this]
}
