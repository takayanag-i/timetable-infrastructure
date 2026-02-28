variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "account_id" {
  description = "サービスアカウントID (例: firebase-admin-sa)"
  type        = string
  default     = "firebase-admin-sa"
}

variable "display_name" {
  description = "サービスアカウントの表示名"
  type        = string
  default     = "Firebase Admin Service Account"
}

variable "description" {
  description = "サービスアカウントの説明"
  type        = string
  default     = "Firebase Admin SDKを使用するためのサービスアカウント（テストユーザー作成・カスタムクレーム設定用）"
}

