variable "aws_production_access_key" {}
variable "aws_production_secret_key" {}
variable "aws_production_region" {}

variable "cluster_domain_zone" {}
variable "cluster_domain_rancher" {}
variable "cluster_domain_monitoring" {}
variable "cluster_domain_prometheus" {}
variable "cluster_domain_kibana" {}
variable "cluster_domain_elasticsearch_hq" {}

provider "aws" {
  version = ">= 1.15"
  access_key = "${var.aws_production_access_key}"
  secret_key = "${var.aws_production_secret_key}"
  region = "${var.aws_production_region}"
}

# resource "aws_route53_zone" "workspace" {
#   name = "development.livingdocs.io"

#   tags {
#     Environment = "development"
#   }
# }

# resource "aws_route53_record" "workspace_root" {
#   zone_id = "${aws_route53_zone.workspace.zone_id}"
#   name    = "${terraform.workspace}.livingdocs.io"
#   type    = "NS"
#   ttl     = "30"

#   records = [
#     "${aws_route53_zone.workspace.name_servers.0}",
#     "${aws_route53_zone.workspace.name_servers.1}",
#     "${aws_route53_zone.workspace.name_servers.2}",
#     "${aws_route53_zone.workspace.name_servers.3}",
#   ]
# }

data "aws_route53_zone" "main" {
  name = "${var.cluster_domain_zone}"
}

resource "aws_route53_record" "monitoring" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.cluster_domain_monitoring}"
  type    = "A"
  ttl     = "30"

  records = ["${digitalocean_droplet.monitoring.*.ipv4_address}"]
}

resource "aws_route53_record" "rancher" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.cluster_domain_rancher}"
  type    = "A"
  ttl     = "30"

  records = ["${digitalocean_droplet.monitoring.*.ipv4_address}"]
}

resource "aws_route53_record" "prometheus" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.cluster_domain_prometheus}"
  type    = "A"
  ttl     = "30"

  records = ["${digitalocean_droplet.monitoring.*.ipv4_address}"]
}

resource "aws_route53_record" "elasticsearch-hq" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.cluster_domain_elasticsearch_hq}"
  type    = "A"
  ttl     = "30"

  records = ["${digitalocean_droplet.monitoring.*.ipv4_address}"]
}

resource "aws_route53_record" "kibana" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.cluster_domain_kibana}"
  type    = "A"
  ttl     = "30"

  records = ["${digitalocean_droplet.monitoring.*.ipv4_address}"]
}
