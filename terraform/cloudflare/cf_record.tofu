locals {
  tunnel_uri = "${data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]}.cfargotunnel.com"
}

resource "cloudflare_record" "grafana_homelab" {
  name    = "grafana.${local.domain}"
  type    = "CNAME"
  zone_id = data.sops_file.secrets.data["cloudflare.zone_id"]
  content = local.tunnel_uri
  proxied = true
}