output "service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.main.name
}

output "service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_service.main.status[0].url
}

output "service_id" {
  description = "The ID of the Cloud Run service"
  value       = google_cloud_run_service.main.id
}

output "service_location" {
  description = "The location of the Cloud Run service"
  value       = google_cloud_run_service.main.location
}

output "service_account_email" {
  description = "The email of the service account used by Cloud Run"
  value       = var.service_account_email != null ? var.service_account_email : (var.create_service_account ? google_service_account.cloud_run[0].email : null)
}

output "latest_revision_name" {
  description = "The name of the latest ready revision"
  value       = google_cloud_run_service.main.status[0].latest_ready_revision_name
}
