#Security group
resource "openstack_networking_secgroup_v2" "app_secgroup" {
  name        = "${local.app_name}_secgroup"
  description = "Security group for ${local.app_name}"
}

resource "openstack_networking_secgroup_rule_v2" "app_secgroup_rules" {
  for_each = toset(var.ingress_ports_rules)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.app_secgroup.id
}

# Instance
resource "openstack_compute_instance_v2" "app_instance" {
  name            = "${local.app_name}-${var.app_env}"
  image_name      = local.image_name
  flavor_name     = local.instance_flavor
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.app_secgroup.name]

  network {
    name = local.network_name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.private_key_path}")
    host        = self.access_ip_v4
  }

  # TODO: destroy the ubuntu user
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /root/.ssh",
      "sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/",
      "echo '${var.hatchbox_ssh_key}' | sudo tee -a /root/.ssh/authorized_keys",
      "sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd"
    ]
  }
}

data "cloudflare_accounts" "account" {
  name = local.cloudflare_account
}

data "cloudflare_zone" "domain" {
  name = local.cloudflare_zone_domain
}

resource "cloudflare_record" "app_record" {
  for_each = toset(var.app_dns_records)
  
  zone_id = data.cloudflare_zone.domain.id
  name    = each.value
  value   = openstack_compute_instance_v2.app_instance.access_ip_v4 // Instance IP
  type    = "A"
  ttl     = 1 // 1 for automatic
  proxied = true
  comment = "Set by Terraform, hosted on Infomaniak"
  depends_on = [ openstack_compute_instance_v2.app_instance ]
}

resource "null_resource" "remove_known_host" {
  # The triggers block makes sure that this resource is recreated 
  # every time the instance IP changes
  triggers = {
    instance_ip = openstack_compute_instance_v2.app_instance.access_ip_v4
  }

  # The provisioner runs only when this resource is destroyed
  provisioner "local-exec" {
    when    = destroy
    command = "ssh-keygen -f \"$HOME/.ssh/known_hosts\" -R ${self.triggers.instance_ip}"
  }

  # Ensure this resource is created after the instance
  depends_on = [openstack_compute_instance_v2.app_instance]
}
