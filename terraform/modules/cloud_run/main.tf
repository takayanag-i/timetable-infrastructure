resource "google_cloud_run_service" "main" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    metadata {
      labels = var.labels
      annotations = merge(
        {
          "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
          "autoscaling.knative.dev/minScale" = tostring(var.min_instances)
        },
        var.vpc_connector_name != null ? {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
          "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
        } : {},
        length(var.cloudsql_instances) > 0 ? {
          "run.googleapis.com/cloudsql-instances" = join(",", var.cloudsql_instances)
        } : {}
      )
    }

    spec {
      containers {
        image = var.image

        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }

        # Environment variables
        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.key
            value = env.value
          }
        }

        # Secret environment variables
        dynamic "env" {
          for_each = var.secrets
          content {
            name = env.value.name
            value_from {
              secret_key_ref {
                name = env.value.secret
                key  = env.value.version
              }
            }
          }
        }
      }

      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds
      service_account_name  = var.service_account_email != null ? var.service_account_email : (var.create_service_account ? google_service_account.cloud_run[0].email : null)
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }
}

# Service Account for Cloud Run (optional)
resource "google_service_account" "cloud_run" {
  count        = var.create_service_account ? 1 : 0
  project      = var.project_id
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
}

# IAM binding to allow public access (if enabled)
resource "google_cloud_run_service_iam_member" "public_access" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
