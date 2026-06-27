/**
 * Firebase Admin SDK用のサービスアカウント
 */

# サービスアカウントの作成
resource "google_service_account" "firebase_admin" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
}

# roleの付与: Firebase Authentication Admin
# ユーザーの作成・編集・削除、カスタムクレーム設定のため
resource "google_project_iam_member" "firebase_auth_admin" {
  project = var.project_id
  role    = "roles/firebaseauth.admin"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

# roleの付与: Service Account Token Creator
# IDトークンの生成、サービスアカウントの権限借用のため
resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

# roleの付与: Service Usage Consumer
# Identity Toolkit APIなど、Google APIの使用のため
resource "google_project_iam_member" "service_usage_consumer" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${google_service_account.firebase_admin.email}"
}

