output "workload_identity_provider" {
  description = "GitHub Actionsの google-github-actions/auth に渡す provider の完全名"
  value       = google_iam_workload_identity_pool_provider.github_actions.name
}

output "service_account_email" {
  description = "GitHub Actionsが借用するサービスアカウントのメールアドレス"
  value       = google_service_account.schema_applier.email
}

output "database_user_name" {
  description = "DB側のIAMユーザー名（GRANT実行時に使う）"
  value       = google_sql_user.schema_applier.name
}
