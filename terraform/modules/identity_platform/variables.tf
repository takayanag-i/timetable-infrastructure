variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "authorized_domains" {
  description = "認証済みドメインのリスト（フロントエンドのオリジン）"
  type        = list(string)
  default     = []
}
