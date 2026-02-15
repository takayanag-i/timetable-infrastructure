variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "database_version" {
  description = "Database version (POSTGRES_14, POSTGRES_15, etc.)"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Machine type tier"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "Availability type (ZONAL or REGIONAL)"
  type        = string
  default     = "ZONAL"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "disk_autoresize" {
  description = "Enable disk autoresize"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Backup start time (HH:MM format)"
  type        = string
  default     = "07:00"
}

variable "backup_location" {
  description = "Backup location (e.g., asia, us, eu)"
  type        = string
  default     = null
}

variable "maintenance_window_day" {
  description = "Maintenance window day (1-7, Monday-Sunday)"
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "Maintenance window hour (0-23)"
  type        = number
  default     = 0
}

variable "maintenance_window_update_track" {
  description = "Maintenance window update track (canary or stable)"
  type        = string
  default     = "canary"
}

variable "database_flags" {
  description = "Database flags"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "authorized_networks" {
  description = "Authorized networks for SQL instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ipv4_enabled" {
  description = "Enable IPv4"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "VPC network for private IP"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "databases" {
  description = "List of databases to create"
  type = list(object({
    name    = string
    charset = string
    collation = string
  }))
  default = []
}

variable "users" {
  description = "List of users to create"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "password_validation_enabled" {
  description = "Enable password validation policy"
  type        = bool
  default     = false
}

variable "password_min_length" {
  description = "Minimum password length"
  type        = number
  default     = 8
}
