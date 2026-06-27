output "queue_name" {
  description = "Cloud Tasks queue name"
  value       = google_cloud_tasks_queue.main.name
}

output "queue_id" {
  description = "Cloud Tasks queue ID"
  value       = google_cloud_tasks_queue.main.id
}

output "queue_path" {
  description = "Full resource path (projects/{project}/locations/{location}/queues/{queue})"
  value       = "projects/${var.project_id}/locations/${var.region}/queues/${google_cloud_tasks_queue.main.name}"
}
