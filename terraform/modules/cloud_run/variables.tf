variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "image" {
  description = "Container image URL"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret environment variables (from Secret Manager)"
  type = list(object({
    name   = string
    secret = string
    version = string
  }))
  default = []
}

variable "cpu" {
  description = "CPU allocation for the container"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocation for the container"
  type        = string
  default     = "512Mi"
}

variable "max_instances" {
  description = "Maximum number of container instances"
  type        = number
  default     = 10
}

variable "min_instances" {
  description = "Minimum number of container instances"
  type        = number
  default     = 0
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

variable "ingress" {
  description = "Ingress traffic allowed (all, internal, internal-and-cloud-load-balancing)"
  type        = string
  default     = "all"
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access"
  type        = bool
  default     = true
}

variable "vpc_connector_name" {
  description = "VPC connector name for connecting to VPC resources"
  type        = string
  default     = null
}

variable "cloudsql_instances" {
  description = "Cloud SQL instances to connect to"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels to apply to the service"
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account email to use for Cloud Run (if not specified, creates a new one)"
  type        = string
  default     = null
}

variable "create_service_account" {
  description = "Whether to create a new service account"
  type        = bool
  default     = true
}

variable "container_concurrency" {
  description = "Maximum number of concurrent requests per container"
  type        = number
  default     = 80
}
