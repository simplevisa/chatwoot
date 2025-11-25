locals  {
  app_name = "chatwoot"
  region_name = "dc3-a"
  interface = "public"
  identity_api_version = "3"
  instance_flavor = "a4-ram16-disk50-perf1"
  image_name = "Ubuntu 22.04 LTS Jammy Jellyfish"
  network_name = "ext-net1"
  instance_ip = openstack_compute_instance_v2.app_instance.access_ip_v4
  cloudflare_account       = "Simple"
  cloudflare_zone_domain   = "simplevisa.net"
}

variable "auth_url" {
  description = "The OpenStack authentication URL"
  type        = string
}

variable "project_id" {
  description = "The OpenStack project ID"
  type        = string
}

variable "tenant_name" {
  description = "The OpenStack project name"
  type        = string
}

variable "username" {
  description = "Username for OpenStack authentication"
  type        = string
}

variable "password" {
  description = "Password for OpenStack authentication"
  type        = string
  sensitive   = true
}

# Instance

variable "key_pair" {
  description = "The name of the key pair to use for the instance"
  type        = string
}

variable "ingress_ports_rules" {
  description = "List of ports to open on the instance"
  type        = list(string)
  default     = [22, 80, 443]
}

variable "cloudflare_email" {
  description = "The email address associated with the Cloudflare account"
  type        = string
}

variable "cloudflare_api_key" {
  description = "The API key associated with the Cloudflare account"
  type        = string
  sensitive   = true
}

variable "app_env" {
  description = "The environment of the application"
  type        = string
}

variable "app_dns_records" {
  description = "List of application dns records to be created"
  type        = list(string)
}

# Hatchbox
variable "hatchbox_ssh_key" {
  description = "The public key to use for Hatchbox"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private key to use for the instance"
  type        = string
  default     = "~/.ssh/id_ed25519"
}