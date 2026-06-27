# Cloud Tasks Queue for optimization jobs
resource "google_cloud_tasks_queue" "main" {
  name     = var.queue_name
  location = var.region
  project  = var.project_id

  rate_limits {
    max_concurrent_dispatches = var.max_concurrent_dispatches
    max_dispatches_per_second = var.max_dispatches_per_second
  }

  retry_config {
    max_attempts = var.max_attempts
    # No retry — optimization jobs are not idempotent
  }

  stackdriver_logging_config {
    sampling_ratio = var.logging_sampling_ratio
  }
}

# IAM binding: allow the specified service account to enqueue tasks
resource "google_cloud_tasks_queue_iam_member" "enqueuer" {
  count    = var.enqueuer_service_account_email != null ? 1 : 0
  project  = var.project_id
  location = var.region
  name     = google_cloud_tasks_queue.main.name
  role     = "roles/cloudtasks.enqueuer"
  member   = "serviceAccount:${var.enqueuer_service_account_email}"
}
