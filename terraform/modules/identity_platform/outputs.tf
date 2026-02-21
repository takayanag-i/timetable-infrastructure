output "api_key" {
  description = "Identity Platform APIキー"
  value       = google_identity_platform_config.default.name
}

output "auth_domain" {
  description = "Identity Platform認証ドメイン"
  value       = "${var.project_id}.firebaseapp.com"
}

output "issuer_uri" {
  description = "JWT Issuer URI"
  value       = "https://securetoken.google.com/${var.project_id}"
}

output "jwks_uri" {
  description = "JWKS URI"
  value       = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com"
}
