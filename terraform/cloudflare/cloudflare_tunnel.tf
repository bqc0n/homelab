resource "cloudflare_zero_trust_access_application" "homelab_private" {
  zone_id          = local.zone_id
  name             = "Homelab - Private - I"
  session_duration = "24h"
  type             = "self_hosted"
  allowed_idps = [data.sops_file.secrets.data["cloudflare.github_idp_id"]]
  destinations = [
    # Add URIs here for protected apps (5 Max per access_app)
    { type = "public", uri = "grafana.${local.domain}" },
    { type = "public", uri = "argocd.${local.domain}" },
    { type = "public", uri = "homebox.${local.domain}" },
    { type = "public", uri = "docmost.${local.domain}" },
    { type = "public", uri = "wallos.${local.domain}" },
  ]
  auto_redirect_to_identity = true
  policies = [
    {
      precedence = 1
      id         = cloudflare_zero_trust_access_policy.homelab_private.id
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "homelab_private_2" {
  zone_id          = local.zone_id
  name             = "Homelab - Private - II"
  session_duration = "24h"
  type             = "self_hosted"
  allowed_idps = [data.sops_file.secrets.data["cloudflare.github_idp_id"]]
  destinations = [
    # Add URIs here for protected apps (5 Max per access_app)
    { type = "public", uri = "paperless.${local.domain}" },
    { type = "public", uri = "plane.${local.domain}" },
  ]
  auto_redirect_to_identity = true
  policies = [
    {
      precedence = 1
      id         = cloudflare_zero_trust_access_policy.homelab_private.id
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "homelab_protected" {
  zone_id          = local.zone_id
  name             = "Homelab - Protected - Friends - I"
  session_duration = "72h"
  type             = "self_hosted"
  allowed_idps = [data.sops_file.secrets.data["cloudflare.github_idp_id"]]
  destinations = [
    # Add URIs here for protected apps (5 Max per access_app)
    { type = "public", uri = "redmine.${local.domain}" },
  ]
  auto_redirect_to_identity = true
  policies = [
    {
      precedence = 1
      id         = cloudflare_zero_trust_access_policy.homelab_protected_friends.id
    }
  ]
}

resource "cloudflare_zero_trust_access_policy" "homelab_private" {
  account_id = local.account_id
  decision   = "allow"
  name       = "Homelab | Private"
  include = [
    { email = { email = data.sops_file.secrets.data["email1"] } },
  ]
}

resource "cloudflare_zero_trust_access_policy" "homelab_protected_friends" {
  account_id = local.account_id
  decision   = "allow"
  name       = "Homelab | Protected | Friends"
  include = [
    { email = { email = data.sops_file.secrets.data["email1"] } },
    { email = { email = data.sops_file.secrets.data["email2"] } },
    { email = { email = data.sops_file.secrets.data["email3"] } },
    { email = { email = data.sops_file.secrets.data["email4"] } },
    { email = { email = data.sops_file.secrets.data["email5"] } },
    { email = { email = data.sops_file.secrets.data["email6"] } },
  ]
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "cf_grafana" {
  account_id = local.account_id
  tunnel_id  = data.sops_file.secrets.data["cloudflare.homelab_tunnel_id"]
  config = {
    # These are forwarding settings for the tunnel
    ingress = [
      {
        hostname = "grafana.${local.domain}"
        service  = "http://grafana-dashboard-service.dash.svc.cluster.local.:3000"
      }, {
        hostname = "argocd.${local.domain}"
        service  = "https://argocd-server.argocd.svc.cluster.local."
        origin_request = { no_tls_verify = true }
      }, {
        hostname = "homebox.${local.domain}"
        service  = "http://homebox.web-apps.svc.cluster.local."
      }, {
        hostname = "misskey.${local.domain}"
        service  = "http://misskey.web-apps.svc.cluster.local."
      }, {
        hostname = "s3.${local.domain}"
        service  = "http://ceph-rgw.default.svc.cluster.local."
      }, {
        hostname = "docmost.${local.domain}"
        service  = "http://docmost.docmost.svc.cluster.local."
      }, {
        hostname = "paperless.${local.domain}"
        service  = "http://server.paperless-ngx.svc.cluster.local."
      }, {
        hostname = "redmine.${local.domain}"
        service  = "http://redmine.web-apps.svc.cluster.local."
      }, {
        hostname = "minio.${local.domain}"
        service  = "http://192.168.1.32:9001"
      }, {
        hostname = "s4.${local.domain}"
        service  = "http://192.168.1.32:9000"
      }, {
        hostname = "wallos.${local.domain}"
        service  = "http://wallos.web-apps.svc.cluster.local."
      }, {
        hostname = "plane.${local.domain}"
        service  = "http://plane-app-web.plane-ce.svc.cluster.local."
      }, {
        hostname = "matrix.${local.domain}"
        service  = "http://synapse.web-apps.svc.cluster.local."
      },{
        service = "http_status:404"
      }
    ]
  }
}