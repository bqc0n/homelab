resource "cloudflare_zero_trust_access_application" "homelab_private" {
  zone_id = local.zone_id
  name = "Homelab - Private"
  session_duration = "24h"
  type = "self_hosted"
  allowed_idps = [data.sops_file.secrets.data["cloudflare.github_idp_id"]]
  destinations = [
    { type = "public", uri = "grafana.${local.domain}" },
    { type = "public", uri = "argocd.${local.domain}" },
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
      service = "http://grafana-svc.dash.svc.cluster.local."
    }, {
      hostname = "argocd.${local.domain}"
      service = "https://argocd-server.argocd.svc.cluster.local."
      origin_request = { no_tls_verify = true }
    }, {
      service = "http_status:404"
    }]
  }
}