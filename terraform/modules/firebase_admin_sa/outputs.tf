output "service_account_email" {
  description = "Firebase Admin サービスアカウントのメールアドレス"
  value       = google_service_account.firebase_admin.email
}

output "service_account_id" {
  description = "Firebase Admin サービスアカウントのID"
  value       = google_service_account.firebase_admin.unique_id
}

output "service_account_name" {
  description = "Firebase Admin サービスアカウントのリソース名"
  value       = google_service_account.firebase_admin.name
}

