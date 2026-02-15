# timetable-infrastructure

時間割アプリのインフラストラクチャをTerraformで管理します。

## 概要

このリポジトリは、時間割アプリケーションのGoogle Cloud Platformインフラをコードとして管理（Infrastructure as Code）するためのTerraform設定を含んでいます。

### 管理対象リソース

- **Cloud Run**: アプリケーションのコンテナ実行環境
- **Cloud SQL**: PostgreSQLデータベース
- **IAM**: サービスアカウントと権限管理

### 環境

- **sandbox**: 既存リソースを管理する実験・検証環境
- **dev**: 開発環境（将来実装予定）
- **prod**: 本番環境（将来実装予定）

## ディレクトリ構成

```
infra/
├── terraform/
│   ├── environments/           # 環境別の設定
│   │   └── sandbox/           # Sandbox環境
│   │       ├── main.tf        # メイン設定
│   │       ├── variables.tf   # 変数定義
│   │       ├── outputs.tf     # 出力定義
│   │       ├── backend.tf     # State管理設定
│   │       └── terraform.tfvars.example  # 設定例
│   └── modules/               # 再利用可能なモジュール
│       ├── cloud_run/         # Cloud Runモジュール
│       ├── cloud_sql/         # Cloud SQLモジュール
│       ├── vpc/               # VPCモジュール
│       └── iam/               # IAMモジュール
└── scripts/                   # ヘルパースクリプト
    ├── setup.sh              # 初期セットアップ
    └── import-sandbox-resources.sh  # リソースインポート
```

## 前提条件

### 必要なツール

- [Terraform](https://www.terraform.io/downloads) (>= 1.5.0)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Bash (スクリプト実行用)

### インストール確認

```bash
# Terraform
terraform version

# gcloud CLI
gcloud version

# 認証確認
gcloud auth list
```

## セットアップ手順

### 1. 初期セットアップ

```bash
cd infra
./scripts/setup.sh
```

このスクリプトは以下を実行します：
- 必要なGCP APIの有効化
- Terraform State用GCSバケットの作成（オプション）
- `terraform.tfvars`の生成

### 2. 設定ファイルの編集

```bash
cd terraform/environments/sandbox
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars`を編集し、以下の値を設定します：

```hcl
project_id = "your-gcp-project-id"
region     = "asia-northeast1"

cloud_run_service_name = "your-service-name"
cloud_run_image        = "gcr.io/your-project/your-image:tag"

cloud_sql_instance_name = "your-sql-instance"
# その他の設定...
```

**⚠️ 重要**: `terraform.tfvars`には機密情報が含まれるため、`.gitignore`に含まれています。コミットしないでください。

### 3. Terraformの初期化

```bash
cd terraform/environments/sandbox
terraform init
```

### 4. 既存リソースのインポート

既存のCloud RunとCloud SQLをTerraformの管理下に取り込みます：

```bash
cd infra
./scripts/import-sandbox-resources.sh
```

#### 個別インポート

データベースやユーザーを個別にインポートする場合：

```bash
cd terraform/environments/sandbox

# データベースのインポート
terraform import 'module.cloud_sql.google_sql_database.databases["timetable"]' \
  PROJECT_ID/INSTANCE_NAME/timetable

# ユーザーのインポート
terraform import 'module.cloud_sql.google_sql_user.users["app_user"]' \
  PROJECT_ID/INSTANCE_NAME/app_user
```

### 5. 設定の確認

```bash
cd terraform/environments/sandbox
terraform plan
```

**期待される結果**: 差分が表示されない、または最小限の差分のみ

差分がある場合は、`terraform.tfvars`を調整して実際のリソース設定に合わせます。

### 6. 変更の適用

設定を変更した場合：

```bash
terraform apply
```

## 日常的な運用

### 設定変更の流れ

1. **変更前の確認**
   ```bash
   terraform plan
   ```

2. **変更の適用**
   ```bash
   terraform apply
   ```

3. **適用結果の確認**
   ```bash
   terraform show
   ```

### リソースの状態確認

```bash
# すべてのリソースを表示
terraform state list

# 特定のリソースの詳細を表示
terraform state show module.cloud_run.google_cloud_run_service.main
```

### State管理

#### Stateのバックアップ

```bash
terraform state pull > terraform.tfstate.backup
```

#### Stateの同期

```bash
terraform refresh
```

## トラブルシューティング

### よくある問題

#### 1. インポート時にリソースが見つからない

**原因**: リソース名やプロジェクトIDが間違っている

**解決方法**:
```bash
# 実際のリソースを確認
gcloud run services list
gcloud sql instances list
```

#### 2. terraform planで差分が出る

**原因**: 実際のリソース設定と`terraform.tfvars`の値が一致していない

**解決方法**:
- GCPコンソールで実際の設定を確認
- `terraform.tfvars`を実際の設定に合わせる

#### 3. 権限エラー

**原因**: GCPの権限が不足している

**解決方法**:
```bash
# 必要な権限を確認
gcloud projects get-iam-policy PROJECT_ID

# 自分のアカウントに権限を付与（プロジェクトオーナーが実行）
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:your-email@example.com" \
  --role="roles/editor"
```

## セキュリティ

### 機密情報の管理

- `terraform.tfvars`: Gitにコミットしない（`.gitignore`に含まれています）
- データベースパスワード: Secret Managerの使用を推奨
- サービスアカウントキー: ローカルに保存せず、Cloud IAMで管理

### 推奨事項

- 本番環境では`deletion_protection = true`を設定
- Cloud SQLは常にバックアップを有効化
- Private IPを使用してCloud RunとCloud SQLを接続

## Stateファイルのバックエンド設定

現在はローカルでStateを管理していますが、チーム開発の場合はGCSバックエンドの使用を推奨します。

### GCSバックエンドの設定

1. **`backend.tf`のコメント解除**:

```hcl
backend "gcs" {
  bucket = "YOUR_PROJECT_ID-terraform-state"
  prefix = "sandbox"
}
```

2. **State の移行**:

```bash
terraform init -migrate-state
```

## 参考資料

- [Terraform Google Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices-for-terraform)
- [Terraform Import Documentation](https://www.terraform.io/docs/cli/import/index.html)

## ライセンス

プロジェクトのライセンスに準じます。
