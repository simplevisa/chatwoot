terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare",
      version = "~> 4.20"
    }
  }
}

provider "openstack" {
  user_name   = var.username
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
  region      = local.region_name
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
