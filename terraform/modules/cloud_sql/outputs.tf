output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = google_sql_database_instance.main.name
}

output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.main.connection_name
}

output "instance_self_link" {
  description = "The URI of the Cloud SQL instance"
  value       = google_sql_database_instance.main.self_link
}

output "instance_ip_address" {
  description = "The IPv4 address of the Cloud SQL instance"
  value       = length(google_sql_database_instance.main.ip_address) > 0 ? google_sql_database_instance.main.ip_address[0].ip_address : null
}

output "private_ip_address" {
  description = "The private IP address of the Cloud SQL instance"
  value       = try(google_sql_database_instance.main.private_ip_address, null)
}

output "database_names" {
  description = "The names of the databases"
  value       = [for db in google_sql_database.databases : db.name]
}

output "user_names" {
  description = "The names of the users"
  value       = [for user in google_sql_user.users : user.name]
}
