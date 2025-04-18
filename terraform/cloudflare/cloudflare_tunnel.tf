resource "cloudflare_zero_trust_access_application" "homelab_private" {
  zone_id = local.zone_id
  name = "Homelab - Private"
  session_duration = "24h"
  type = "self_hosted"
  allowed_idps = [data.sops_file.secrets.data["cloudflare.github_idp_id"]]
  destinations = [
    { type = "public", uri = "grafana.${local.domain}" },
    { type = "public", uri = "argocd.${local.domain}" },
    { type = "public", uri = "homebox.${local.domain}" },
    { type = "public", uri = "docmost.${local.domain}" },
    { type = "public", uri = "paperless.${local.domain}" },
  ]
  auto_redirect_to_identity = true
  policies = [{
    precedence = 1
    decision = "allow"
    id = cloudflare_zero_trust_access_policy.homelab_private.id
  }]
}

resource "cloudflare_zero_trust_access_policy" "homelab_private" {
  account_id = local.account_id
  decision = "allow"
  name     = "Homelab | Private"
  include = [{
    email = { email = data.sops_file.secrets.data["email1"] }
  }]
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "cf_grafana" {
  account_id = local.account_id
  tunnel_id  = data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]
  config = {
    ingress = [{
      hostname = "grafana.${local.domain}"
      service = "http://grafana-dashboard-service.dash.svc.cluster.local.:3000"
    }, {
      hostname = "argocd.${local.domain}"
      service = "https://argocd-server.argocd.svc.cluster.local."
      origin_request = { no_tls_verify = true }
    }, {
      hostname = "homebox.${local.domain}"
      service = "http://homebox.homebox.svc.cluster.local."
    }, {
      hostname = "misskey.${local.domain}"
      service = "http://misskey.misskey.svc.cluster.local."
    }, {
      hostname = "s3.${local.domain}"
      service = "http://ceph-rgw.default.svc.cluster.local."
    }, {
      hostname = "docmost.${local.domain}"
      service = "http://docmost.docmost.svc.cluster.local."
    }, {
      hostname = "paperless.${local.domain}"
      service = "http://server.paperless-ngx.svc.cluster.local."
    }, {
      hostname = "immich.${local.domain}"
      service = "http://frontend.immich.svc.cluster.local."
    }, {
      service = "http_status:404"
    }]
  }
}