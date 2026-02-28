/**
 * Firebase Admin Service Account Module
 * Firebase Admin SDK用のサービスアカウントとIAMバインディングを管理
 */

# Firebase Admin用サービスアカウントの作成
resource "google_service_account" "firebase_admin" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
}

# Firebase Authentication Admin権限
# ユーザーの作成・編集・削除、カスタムクレームの設定に必要
resource "google_project_iam_member" "firebase_auth_admin" {
  project = var.project_id
  role    = "roles/firebaseauth.admin"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

# Service Account Token Creator権限
# IDトークンの生成やサービスアカウントの権限借用に必要
resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

# Service Usage Consumer権限
# Identity Toolkit APIなど、Google APIの使用に必要
resource "google_project_iam_member" "service_usage_consumer" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

