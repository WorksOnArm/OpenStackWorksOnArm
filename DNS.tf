provider "dnsimple" {
}

resource "dnsimple_record" "controller-dns" {
  domain = "openstacksandiego.us"
  name   = "controller-${random_id.cloud.hex}"
  value  = "${packet_device.dashboard.access_public_ipv4}"
  type   = "A"
  ttl    = 3600
}

resource "dnsimple_record" "dashboard-dns" {
  domain = "openstacksandiego.us"
  name   = "dashboard-${random_id.cloud.hex}"
  value  = "${packet_device.dashboard.access_public_ipv4}"
  type   = "A"
  ttl    = 3600
}
