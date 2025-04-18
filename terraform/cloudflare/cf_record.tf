locals {
  tunnel_uri = "${data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]}.cfargotunnel.com"
  tunneled = [
    "grafana.${local.domain}",
    "argocd.${local.domain}",
    "homebox.${local.domain}",
    "misskey.${local.domain}",
    "s3.${local.domain}",
    "docmost.${local.domain}",
    "paperless.${local.domain}",
    "immich.${local.domain}",
  ]
}

resource "cloudflare_dns_record" "tunneled_records" {
  for_each = toset(local.tunneled)
  name    = each.key
  type    = "CNAME"
  zone_id = local.zone_id
  content = local.tunnel_uri
  proxied = true
  ttl     = 1 # TTL must be "automatic" for proxied records
}

resource "cloudflare_dns_record" "minecraft_proxy_ipv4" {
  name    = "minecraft.bqc0n.com"
  ttl     = 3600
  type    = "A"
  zone_id = local.zone_id
  content = data.terraform_remote_state.cloud.outputs.minecraft_amd_osaka_public_ipv4
}

resource "cloudflare_dns_record" "minecraft_proxy_ipv6" {
  name    = "minecraft.bqc0n.com"
  ttl     = 3600
  type    = "AAAA"
  zone_id = local.zone_id
  content = data.terraform_remote_state.cloud.outputs.minecraft_amd_osaka_ipv6_GUA
}