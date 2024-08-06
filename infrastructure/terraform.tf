terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.48.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  cloud {
    organization = "rke-kata-containers"
    workspaces {
      name = "rke-kata-containers"
    }
  }
}
