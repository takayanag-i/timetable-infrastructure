variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "account_id" {
  description = "サービスアカウントID"
  type        = string
  default     = "firebase-admin-sa"
}

variable "display_name" {
  description = "表示名"
  type        = string
  default     = "Firebase Admin Service Account"
}

variable "description" {
  description = "説明"
  type        = string
  default     = "Firebase Admin SDK用のサービスアカウント"
}

