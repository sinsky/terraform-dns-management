terraform {
  required_version = "1.13.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

module "sinsky_me" {
  source    = "./modules/sinsky.me"
  api_token = var.cloudflare_api_token_sinsky_me
  zone_id   = var.cloudflare_zone_id_sinsky_me
}
