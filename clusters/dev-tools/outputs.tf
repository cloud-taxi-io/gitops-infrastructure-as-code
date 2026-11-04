output "servers" {
  description = "Name, public IPv4 and private IP of each VM."
  value = {
    for s in hcloud_server.node : s.name => {
      public_ipv4 = s.ipv4_address
      private_ip  = one(s.network[*].ip)
      role        = s.labels["role"]
    }
  }
}
