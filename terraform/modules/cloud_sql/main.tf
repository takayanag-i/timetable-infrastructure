resource "google_sql_database_instance" "main" {
  project             = var.project_id
  name                = var.instance_name
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    disk_autoresize   = var.disk_autoresize

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      location                       = var.backup_location
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    dynamic "password_validation_policy" {
      for_each = var.password_validation_enabled ? [1] : []
      content {
        enable_password_policy      = true
        min_length                  = var.password_min_length
        complexity                  = "COMPLEXITY_DEFAULT"
        disallow_username_substring = true
      }
    }

    user_labels = var.labels
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      settings[0].disk_size,
    ]
  }
}

# Create databases
resource "google_sql_database" "databases" {
  for_each = { for db in var.databases : db.name => db }

  project   = var.project_id
  name      = each.value.name
  instance  = google_sql_database_instance.main.name
  charset   = each.value.charset
  collation = each.value.collation
}

# Create users
resource "google_sql_user" "users" {
  for_each = { for user in var.users : user.name => user }

  project  = var.project_id
  name     = each.value.name
  instance = google_sql_database_instance.main.name
  password = each.value.password
}
