terraform {
  required_version = "1.13.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

locals {
  vps         = yamldecode(file("${path.module}/vps.yaml"))
  dns_records = merge(local.vps)
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_dns_record" "records" {
  for_each = local.dns_records

  zone_id  = var.zone_id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  ttl      = lookup(each.value, "ttl", 1) // Default to Auto = 1
  proxied  = lookup(each.value, "proxied", false)
  priority = lookup(each.value, "priority", null)
  comment  = lookup(each.value, "comment", null)
}
