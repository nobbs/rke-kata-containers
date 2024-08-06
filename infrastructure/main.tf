resource "hcloud_ssh_key" "me" {
  name = "nobbs"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCBMdl3Z8zgAUVF5AeY8hz3vcnkrJ+dPh3yYIKGm2ZO"
}

resource "hcloud_server" "node" {
  count = 3

  name        = "node-${count.index}"
  server_type = "cx42"
  image       = "rocky-8"

  location = "nbg1"

  ssh_keys  = [hcloud_ssh_key.me.id]
}

output "nodes" {
  value = [
    for node in hcloud_server.node : {
      name = node.name
      ipv4 = node.ipv4_address
    }
  ]
}
