variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id_sinsky_me" {
  description = "Cloudflare Zone ID for the sinsky.me zone"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token_sinsky_me" {
  description = "Cloudflare API token for sinsky.me zone"
  type        = string
  sensitive   = true
}

# variable "cloudflare_zone_id_sinsky_cc" {
#   description = "Cloudflare Zone ID for the sinsky.cc zone"
#   type        = string
#   sensitive   = true
# }

# variable "cloudflare_api_token_sinsky_cc" {
#   description = "Cloudflare API token for sinsky.cc zone"
#   type        = string
#   sensitive   = true
# }
