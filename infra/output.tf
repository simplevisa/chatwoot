output "instance_ip" {
  value = local.instance_ip
}

resource "local_file" "instance_ip" {
    content  = "[servers]\n${local.instance_ip}"
    filename = "inventory.ini"
}
