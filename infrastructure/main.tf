resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "rke" {
  name       = "rke"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "hcloud_ssh_key" "me" {
  name       = "me"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCBMdl3Z8zgAUVF5AeY8hz3vcnkrJ+dPh3yYIKGm2ZO"
}

resource "hcloud_server" "node" {
  count = 3

  name        = "node-${count.index}"
  server_type = "cx42"
  image       = "ubuntu-22.04"

  location = "nbg1"

  ssh_keys = [
    hcloud_ssh_key.me.id,
    hcloud_ssh_key.rke.id
  ]

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true

    packages:
      - curl
      - apt-transport-https
      - ca-certificates
      - wget

    groups:
      - name: docker
        gid: "999"

    runcmd:
      - curl -fsSL https://get.docker.com | sh
      - reboot
    EOF
}

output "rke_cluster_yml" {
  sensitive = true

  value = yamlencode({
    nodes : [
      for node in hcloud_server.node : {
        address : node.ipv4_address
        role : ["controlplane", "worker", "etcd"]
        user : "root"
        ssh_key : tls_private_key.ssh.private_key_pem
      }
    ]
  })
}
