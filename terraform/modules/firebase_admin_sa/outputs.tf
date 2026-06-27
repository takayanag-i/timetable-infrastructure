output "service_account_email" {
  description = "メールアドレス"
  value       = google_service_account.firebase_admin.email
}

output "service_account_id" {
  description = "サービスアカウントID"
  value       = google_service_account.firebase_admin.unique_id
}

output "service_account_name" {
  description = "リソース名"
  value       = google_service_account.firebase_admin.name
}

