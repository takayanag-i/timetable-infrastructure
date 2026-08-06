output "cloud_run_service_url" {
  description = "Cloud Run service URL"
  value       = module.cloud_run.service_url
}

output "cloud_run_service_name" {
  description = "Cloud Run service name"
  value       = module.cloud_run.service_name
}

output "cloud_run_service_account" {
  description = "Cloud Run service account email"
  value       = module.cloud_run.service_account_email
}

output "fastapi_service_url" {
  description = "FastAPI最適化ワーカーのURL（SpringのCLOUD_TASKS_WORKER_URLに設定する）"
  value       = module.cloud_run_fastapi.service_url
}

output "fastapi_service_name" {
  description = "FastAPI最適化ワーカーのサービス名"
  value       = module.cloud_run_fastapi.service_name
}

output "fastapi_service_account" {
  description = "FastAPI最適化ワーカーの実行SA（SpringのSERVICE_AUTH_SAに設定する）"
  value       = module.cloud_run_fastapi.service_account_email
}

output "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  value       = module.cloud_sql.instance_name
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL connection name"
  value       = module.cloud_sql.instance_connection_name
}

output "cloud_sql_instance_ip" {
  description = "Cloud SQL instance IP address"
  value       = module.cloud_sql.instance_ip_address
}

output "cloud_sql_databases" {
  description = "List of database names"
  value       = module.cloud_sql.database_names
}

# Identity Platform outputs
output "identity_platform_issuer_uri" {
  description = "Identity Platform JWT Issuer URI (Spring Bootで使用)"
  value       = module.identity_platform.issuer_uri
}

output "identity_platform_jwks_uri" {
  description = "Identity Platform JWKS URI (Spring Bootで使用)"
  value       = module.identity_platform.jwks_uri
}

output "identity_platform_auth_domain" {
  description = "Identity Platform認証ドメイン (フロントエンドで使用)"
  value       = module.identity_platform.auth_domain
}

# Firebase Admin Service Account outputs
output "firebase_admin_sa_email" {
  description = "Firebase Admin サービスアカウントのメールアドレス"
  value       = module.firebase_admin_sa.service_account_email
}

# Cloud Tasks outputs
output "cloud_tasks_queue_path" {
  description = "Cloud Tasks queue full resource path"
  value       = module.cloud_tasks.queue_path
}

output "schema_apply_workload_identity_provider" {
  description = "GitHub Actionsの google-github-actions/auth に渡す provider（リポジトリ変数に設定する）"
  value       = module.schema_apply_access.workload_identity_provider
}

output "schema_apply_service_account" {
  description = "GitHub Actionsが借用するサービスアカウント（リポジトリ変数に設定する）"
  value       = module.schema_apply_access.service_account_email
}

output "schema_apply_database_user" {
  description = "DB側のIAMユーザー名（初回のロール付与に使う）"
  value       = module.schema_apply_access.database_user_name
}
