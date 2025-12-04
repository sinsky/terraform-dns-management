terraform {
  required_version = "1.14.1"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5"
    }
  }
}

module "sinsky_me" {
  source    = "./modules/sinsky.me"
  api_token = var.cloudflare_api_token_sinsky_me
  zone_id   = var.cloudflare_zone_id_sinsky_me
}

module "sinsky_cc" {
  source    = "./modules/sinsky.cc"
  api_token = var.cloudflare_api_token_sinsky_cc
  zone_id   = var.cloudflare_zone_id_sinsky_cc
}
