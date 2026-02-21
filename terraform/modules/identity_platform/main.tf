/**
 * Identity Platform Module
 * Google Identity Platformの設定を管理
 */

# Identity Platform Config
resource "google_identity_platform_config" "default" {
  project = var.project_id

  # サインイン設定
  sign_in {
    # メール/パスワード認証を有効化
    email {
      enabled           = true
      password_required = true
    }

    # 匿名認証（無効化）
    anonymous {
      enabled = false
    }
  }

  # 認証済みドメイン（フロントエンドのオリジン）
  authorized_domains = var.authorized_domains
}
