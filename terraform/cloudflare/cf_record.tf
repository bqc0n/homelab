locals {
  tunnel_uri = "${data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]}.cfargotunnel.com"
  tunneled = ["grafana.${local.domain}", "misskey.${local.domain}", "argocd.${local.domain}"]
}

resource "cloudflare_dns_record" "tunneled_records" {
  for_each = toset(local.tunneled)
  name    = each.key
  type    = "CNAME"
  zone_id = data.sops_file.secrets.data["cloudflare.zone_id"]
  content = local.tunnel_uri
  proxied = true
  ttl     = 1 # TTL must be "automatic" for proxied records
}