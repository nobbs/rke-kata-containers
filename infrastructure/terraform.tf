terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.48.0"
    }
  }

  cloud {
    organization = "rke-kata-containers"
    workspaces {
        name = "rke-kata-containers"
    }
  }
}
