locals {
  domain = "bqc0n.com"
}

resource "cloudflare_zero_trust_access_application" "homelab_private" {
  zone_id = data.sops_file.secrets.data["cloudflare.zone_id"]
  name = "Homelab | Private"
  session_duration = "24h"
  type = "self_hosted"
  destinations { uri = "grafana.${local.domain}" }
}

resource "cloudflare_zero_trust_access_policy" "homelab_private" {
  application_id = cloudflare_zero_trust_access_application.homelab_private.id
  precedence = 1
  account_id = data.sops_file.secrets.data["cloudflare.account_id"]
  decision = "allow"
  name     = "Homelab | Private"
  include {
    email = [data.sops_file.secrets.data["email1"], data.sops_file.secrets.data["email2"]]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "cf_grafana" {
  account_id = data.sops_file.secrets.data["cloudflare.account_id"]
  tunnel_id  = data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]
  config {
    ingress_rule {
      hostname = "grafana.${local.domain}"
      service = "http://grafana-svc.dash.svc.cluster.local."
    }
    ingress_rule {
      service  = "http_status:404"
    }
  }
}