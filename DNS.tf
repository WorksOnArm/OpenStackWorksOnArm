#provider "dnsimple" {
#}

#
# DNS requires the use of an external DNS provider (DNSSimple)
# DNS is not required for the default setup
#
# These environment variables need to be set from your DNSSimple account
# export DNSIMPLE_ACCOUNT=
# export DNSIMPLE_TOKEN=
#
# $5 off using the link below...
# https://dnsimple.com/r/5e6042aedef10a
#

#resource "dnsimple_record" "controller-dns" {
#  count  = "${var.create_dns}"
#
#  domain = "openstacksandiego.us"
#  name   = "controller-${random_id.cloud.hex}"
#  value  = "${packet_device.dashboard.access_public_ipv4}"
#  type   = "A"
#  ttl    = 3600
#}
#
#resource "dnsimple_record" "dashboard-dns" {
#  count  = "${var.create_dns}"
#
#  domain = "openstacksandiego.us"
#  name   = "dashboard-${random_id.cloud.hex}"
#  value  = "${packet_device.dashboard.access_public_ipv4}"
#  type   = "A"
#  ttl    = 3600
#}
