variable "project_id" {
  description = "GCP Project ID for sandbox environment"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

# Cloud Run variables
variable "cloud_run_service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "cloud_run_image" {
  description = "Container image URL for Cloud Run"
  type        = string
}

variable "cloud_run_env_vars" {
  description = "Environment variables for Cloud Run"
  type        = map(string)
  default     = {}
}

variable "cloud_run_cpu" {
  description = "CPU allocation for Cloud Run"
  type        = string
  default     = "1"
}

variable "cloud_run_memory" {
  description = "Memory allocation for Cloud Run"
  type        = string
  default     = "512Mi"
}

variable "cloud_run_max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
  default     = 10
}

variable "cloud_run_min_instances" {
  description = "Minimum number of Cloud Run instances"
  type        = number
  default     = 0
}

variable "cloud_run_service_account" {
  description = "Service account email for Cloud Run (uses existing if specified)"
  type        = string
  default     = null
}

variable "cloud_run_secrets" {
  description = "Secret environment variables for Cloud Run"
  type = list(object({
    name    = string
    secret  = string
    version = string
  }))
  default = []
}

variable "cloud_run_container_concurrency" {
  description = "Container concurrency for Cloud Run"
  type        = number
  default     = 80
}

# Cloud SQL variables
variable "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "cloud_sql_database_version" {
  description = "Cloud SQL database version"
  type        = string
  default     = "POSTGRES_15"
}

variable "cloud_sql_tier" {
  description = "Cloud SQL machine type tier"
  type        = string
  default     = "db-f1-micro"
}

variable "cloud_sql_disk_size" {
  description = "Cloud SQL disk size in GB"
  type        = number
  default     = 10
}

variable "cloud_sql_deletion_protection" {
  description = "Enable deletion protection for Cloud SQL"
  type        = bool
  default     = true
}

variable "cloud_sql_disk_autoresize" {
  description = "Enable disk autoresize for Cloud SQL"
  type        = bool
  default     = false
}

variable "cloud_sql_backup_location" {
  description = "Backup location (e.g., asia, us, eu)"
  type        = string
  default     = "asia"
}

variable "cloud_sql_password_validation_enabled" {
  description = "Enable password validation policy"
  type        = bool
  default     = true
}

variable "cloud_sql_databases" {
  description = "List of databases to create"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "cloud_sql_authorized_networks" {
  description = "Authorized networks for Cloud SQL"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cloud_sql_backup_start_time" {
  description = "Backup start time (HH:MM format)"
  type        = string
  default     = "07:00"
}

variable "cloud_sql_maintenance_window_day" {
  description = "Maintenance window day (0=Sunday, 1=Monday, etc.)"
  type        = number
  default     = 7
}

variable "cloud_sql_maintenance_window_hour" {
  description = "Maintenance window hour (0-23)"
  type        = number
  default     = 0
}

variable "cloud_sql_maintenance_window_update_track" {
  description = "Maintenance window update track (canary or stable)"
  type        = string
  default     = "canary"
}

variable "cloud_sql_users" {
  description = "List of database users to create"
  type = list(object({
    name     = string
    password = string
  }))
  default   = []
}

# Common variables
variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "sandbox"
    managed_by  = "terraform"
  }
}

# Identity Platform variables
variable "identity_platform_authorized_domains" {
  description = "認証済みドメインのリスト（フロントエンドのオリジン）"
  type        = list(string)
  default     = []
}

# Firebase Admin Service Account variables
variable "firebase_admin_sa_account_id" {
  description = "Firebase Admin サービスアカウントID"
  type        = string
  default     = "firebase-admin-sa"
}

variable "firebase_admin_sa_display_name" {
  description = "Firebase Admin サービスアカウントの表示名"
  type        = string
  default     = "Firebase Admin Service Account"
}

# FastAPI (Optimization Worker) Cloud Run variables
variable "fastapi_service_name" {
  description = "FastAPI最適化ワーカーのCloud Runサービス名"
  type        = string
  default     = "timetable-optimisation-api"
}

variable "fastapi_image" {
  description = "FastAPI最適化ワーカーのコンテナイメージURL"
  type        = string
}

variable "fastapi_env_vars" {
  description = "FastAPI最適化ワーカーの環境変数（INT_API_URL / INT_API_AUDIENCE はSpringのURLから自動設定されるため不要）"
  type        = map(string)
  default     = {}
}

variable "fastapi_secrets" {
  description = "FastAPI最適化ワーカーのシークレット環境変数（Secret Manager）"
  type = list(object({
    name    = string
    secret  = string
    version = string
  }))
  default = []
}

variable "fastapi_cpu" {
  description = "FastAPIのCPUリソース"
  type        = string
  default     = "1000m"
}

variable "fastapi_memory" {
  description = "FastAPIのメモリ"
  type        = string
  default     = "512Mi"
}

variable "fastapi_max_instances" {
  description = "FastAPIの最大インスタンス数"
  type        = number
  default     = 3
}

variable "fastapi_min_instances" {
  description = "FastAPIの最小インスタンス数"
  type        = number
  default     = 0
}

variable "fastapi_container_concurrency" {
  description = "FastAPIの1コンテナあたりの同時リクエスト数"
  type        = number
  default     = 30
}

variable "fastapi_timeout_seconds" {
  description = "FastAPIのリクエストタイムアウト（秒）。最適化はリクエスト内で同期実行されるため、ソルバーのTimeLimitより長く取る"
  type        = number
  default     = 1800
}

variable "fastapi_service_account" {
  description = "FastAPIの実行サービスアカウント（未指定時はcloud_run_service_accountと同じ）"
  type        = string
  default     = null
}

# Cloud Tasks variables
variable "cloud_tasks_queue_name" {
  description = "Cloud Tasks queue name for optimization jobs"
  type        = string
  default     = "optimization-queue"
}

variable "cloud_tasks_max_concurrent_dispatches" {
  description = "Maximum concurrent task dispatches"
  type        = number
  default     = 1
}

variable "cloud_tasks_max_dispatches_per_second" {
  description = "Maximum dispatches per second"
  type        = number
  default     = 1
}

