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
