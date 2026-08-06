variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "github_repository" {
  description = "スキーマ適用を実行するGitHubリポジトリ（owner/repo形式）。これ以外からの認証は受け付けない"
  type        = string
}

variable "cloud_sql_instance_name" {
  description = "スキーマを適用するCloud SQLインスタンス名"
  type        = string
}

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-actions"
}

variable "pool_display_name" {
  description = "Workload Identity Poolの表示名"
  type        = string
  default     = "GitHub Actions"
}

variable "provider_id" {
  description = "Workload Identity Pool Provider ID"
  type        = string
  default     = "github"
}

variable "provider_display_name" {
  description = "Providerの表示名"
  type        = string
  default     = "GitHub"
}

variable "service_account_id" {
  description = "スキーマ適用用サービスアカウントのID"
  type        = string
  default     = "db-schema-applier"
}

variable "service_account_display_name" {
  description = "スキーマ適用用サービスアカウントの表示名"
  type        = string
  default     = "DB Schema Applier"
}
