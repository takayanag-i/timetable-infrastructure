variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "queue_name" {
  description = "Cloud Tasks queue name"
  type        = string
  default     = "optimization-queue"
}

variable "max_concurrent_dispatches" {
  description = "Maximum number of concurrent tasks being dispatched"
  type        = number
  default     = 1
}

variable "max_dispatches_per_second" {
  description = "Maximum rate of task dispatches per second"
  type        = number
  default     = 1
}

variable "max_attempts" {
  description = "Maximum number of attempts for a task (1 = no retry)"
  type        = number
  default     = 1
}

variable "logging_sampling_ratio" {
  description = "Sampling ratio for Stackdriver logging (0.0 to 1.0)"
  type        = number
  default     = 1.0
}

variable "enqueuer_service_account_email" {
  description = "Service account email allowed to enqueue tasks (optional)"
  type        = string
  default     = null
}
