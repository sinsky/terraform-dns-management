variable "api_token" {
  description = "Cloudflare API token for this zone"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "Cloudflare Zone ID for the zone"
  type        = string
}
