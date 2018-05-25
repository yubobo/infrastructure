resource "random_id" "bastion" {
  prefix = "bastion-"
  byte_length = 8
}

resource "digitalocean_tag" "bastion" {name = "bastion"}

data "template_file" "cloud_init" {
  template = "${file("${path.module}/templates/cloud-config.yml")}"
  vars {}
}

resource "digitalocean_droplet" "bastion" {
  name = "${random_id.bastion.hex}"
  image = "rancheros"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  backups = false
  ipv6 = false
  ssh_keys = ["${digitalocean_ssh_key.bastion.fingerprint}"]
  user_data = "${data.template_file.cloud_init.rendered}"
  tags = ["${digitalocean_tag.bastion.id}"]
}

resource "digitalocean_firewall" "bastion" {
  name = "bastion-only-22"
  droplet_ids = ["${digitalocean_droplet.bastion.id}"]

  inbound_rule = [{
    protocol           = "tcp"
    port_range         = "22"
    source_addresses   = ["0.0.0.0/0", "::/0"]
  }]

  outbound_rule = [{
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }, {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }, {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }, {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }, {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }]
}

output "Bastion Name" {
  value = "${digitalocean_droplet.bastion.name}"
}

output "Bastion IP" {
  value = "${digitalocean_droplet.bastion.ipv4_address}"
}