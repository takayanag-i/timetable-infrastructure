# ============================================
# Sandbox Environment - Timetable Application
# ============================================

# Cloud Run Service
module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id   = var.project_id
  region       = var.region
  service_name = var.cloud_run_service_name
  image        = var.cloud_run_image

  environment_variables = var.cloud_run_env_vars
  secrets              = var.cloud_run_secrets

  cpu                   = var.cloud_run_cpu
  memory                = var.cloud_run_memory
  max_instances         = var.cloud_run_max_instances
  min_instances         = var.cloud_run_min_instances
  container_concurrency = var.cloud_run_container_concurrency
  allow_unauthenticated = true
  
  # Use existing service account
  service_account_email  = var.cloud_run_service_account
  create_service_account = var.cloud_run_service_account == null ? true : false
  
  # Connect to Cloud SQL
  cloudsql_instances = [module.cloud_sql.instance_connection_name]

  labels = var.labels
}

# Cloud Run Service (FastAPI Optimization Worker)
module "cloud_run_fastapi" {
  source = "../../modules/cloud_run"

  project_id   = var.project_id
  region       = var.region
  service_name = var.fastapi_service_name
  image        = var.fastapi_image

  # INT_API_URL はSpring（内部API）のURLに自動追従。
  # INT_API_AUDIENCE はSpring側の SERVICE_AUTH_AUDIENCE と完全一致が必要なため同じ値を参照する
  environment_variables = merge(var.fastapi_env_vars, {
    INT_API_URL      = module.cloud_run.service_url
    INT_API_AUDIENCE = lookup(var.cloud_run_env_vars, "SERVICE_AUTH_AUDIENCE", module.cloud_run.service_url)
  })
  secrets = var.fastapi_secrets

  cpu                   = var.fastapi_cpu
  memory                = var.fastapi_memory
  max_instances         = var.fastapi_max_instances
  min_instances         = var.fastapi_min_instances
  container_concurrency = var.fastapi_container_concurrency
  timeout_seconds       = var.fastapi_timeout_seconds
  startup_cpu_boost     = true

  # 公開しない。Cloud TasksのOIDCトークン（CLOUD_TASKS_SA = cloud_run_service_account）
  # による呼び出しのみ許可
  allow_unauthenticated = false
  invoker_members       = ["serviceAccount:${var.cloud_run_service_account}"]

  service_account_email  = coalesce(var.fastapi_service_account, var.cloud_run_service_account)
  create_service_account = false

  labels = var.labels
}

# Cloud SQL Instance
module "cloud_sql" {
  source = "../../modules/cloud_sql"

  project_id       = var.project_id
  region           = var.region
  instance_name    = var.cloud_sql_instance_name
  database_version = var.cloud_sql_database_version
  tier             = var.cloud_sql_tier
  disk_size        = var.cloud_sql_disk_size
  disk_autoresize  = var.cloud_sql_disk_autoresize

  availability_type = "ZONAL"
  backup_enabled    = true
  backup_start_time = var.cloud_sql_backup_start_time
  backup_location   = var.cloud_sql_backup_location

  # Maintenance window
  maintenance_window_day          = var.cloud_sql_maintenance_window_day
  maintenance_window_hour         = var.cloud_sql_maintenance_window_hour
  maintenance_window_update_track = var.cloud_sql_maintenance_window_update_track

  # Password validation policy
  password_validation_enabled = var.cloud_sql_password_validation_enabled

  # Private IP configuration (recommended for production)
  # Uncomment if using VPC connector
  # private_network = "projects/${var.project_id}/global/networks/default"
  # ipv4_enabled    = false

  # For sandbox, allow public IP
  ipv4_enabled        = true
  authorized_networks = var.cloud_sql_authorized_networks

  databases = var.cloud_sql_databases
  users     = var.cloud_sql_users

  deletion_protection = var.cloud_sql_deletion_protection

  labels = var.labels
}

# Identity Platform
module "identity_platform" {
  source = "../../modules/identity_platform"

  project_id         = var.project_id
  authorized_domains = var.identity_platform_authorized_domains
}

# Firebase Admin Service Account
module "firebase_admin_sa" {
  source = "../../modules/firebase_admin_sa"

  project_id   = var.project_id
  account_id   = var.firebase_admin_sa_account_id
  display_name = var.firebase_admin_sa_display_name
}

# SpringがOIDCトークン付きタスクを作成するには、トークン対象SA（CLOUD_TASKS_SA）への
# actAs権限が必要（対象SAが自分自身でも明示的な付与が要る）
resource "google_service_account_iam_member" "spring_acts_as_tasks_oidc_sa" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.cloud_run_service_account}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.cloud_run_service_account}"
}

# Cloud Tasks Queue (Optimization)
module "cloud_tasks" {
  source = "../../modules/cloud_tasks"

  project_id                     = var.project_id
  region                         = var.region
  queue_name                     = var.cloud_tasks_queue_name
  max_concurrent_dispatches      = var.cloud_tasks_max_concurrent_dispatches
  max_dispatches_per_second      = var.cloud_tasks_max_dispatches_per_second
  max_attempts                   = 1
  enqueuer_service_account_email = var.cloud_run_service_account
}
