# GitHub ActionsからDBスキーマを適用するためのアクセス設定。
#
# 鍵もパスワードも持たない経路にする:
#   - GCPへの認証   Workload Identity Federation。サービスアカウントキーを発行しない
#   - DBへの認証    Cloud SQL IAM認証。パスワードを発行しない

# GitHubが発行するOIDCトークンをGCPが信頼するための入口
resource "google_iam_workload_identity_pool" "github_actions" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = "GitHub Actionsからのキーなし認証に使う"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  # 指定リポジトリ以外のトークンを受け付けない。これがないとGitHub上の
  # 任意のリポジトリからこのプロジェクトへ認証できてしまう
  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# スキーマ適用専用のアカウント。他の用途と共有しない
resource "google_service_account" "schema_applier" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = "GitHub ActionsからDBスキーマを適用する"
}

# Cloud SQL Auth Proxy での接続に必要
resource "google_project_iam_member" "schema_applier_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.schema_applier.email}"
}

# IAM認証でDBにログインするために要る。パスワードの代わりになる
resource "google_project_iam_member" "schema_applier_cloudsql_instance_user" {
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.schema_applier.email}"
}

# DB側のログインユーザー。パスワードを持たず、IAMで認証する。
# 既存テーブルを ALTER するにはロール付与が要る。初回のみ手動で、手順は .claude/skills/db-schema
resource "google_sql_user" "schema_applier" {
  project  = var.project_id
  instance = var.cloud_sql_instance_name
  # IAMユーザー名はサービスアカウントのメールから .gserviceaccount.com を除いたもの
  name = trimsuffix(google_service_account.schema_applier.email, ".gserviceaccount.com")
  type = "CLOUD_IAM_SERVICE_ACCOUNT"
}

# 指定リポジトリのワークフローだけがこのアカウントを借用できる
resource "google_service_account_iam_member" "schema_applier_from_github" {
  service_account_id = google_service_account.schema_applier.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_repository}"
}
