# インフラコーディング標準

Terraformが `terraform/`、運用スクリプトが `scripts/`。構成は `environments/<env>/` が `modules/` を組み合わせる。

## コメント

原則は親リポジトリの `CLAUDE.md` が持つ。**コードを読んでも分からないことだけを書く。** ここでは HCL の書式だけを定める。

### description 属性が正本

`variable` / `output` の説明は**コメントではなく `description` に書く**。`terraform output` や `terraform-docs` が拾えるのは `description` だけで、コメントは読み手に届かない。

```hcl
✅ variable "db_instance_name" {
     description = "Cloud SQLインスタンス名。スキーマ適用ジョブが接続先の特定に使う"
     type        = string
   }

❌ # Cloud SQLインスタンス名
   variable "db_instance_name" {
     type = string
   }
```

`description` にも同じ基準がかかる。`description = "インスタンス名"` は変数名の言い換えで価値がない。

### 区切りコメントは索引として許可

変数・リソースが多いファイルでは、グルーピングの見出しを許可する。分類が読み取れることに価値がある。

```hcl
✅ # Cloud SQL variables
✅ # GitHub Actions — DBスキーマ適用
```

### リソースに書いてよいこと

宣言を読んでも分からない**外から来た制約**。クラウド側の仕様・クォータ・順序依存が主。

```hcl
✅ # Atlasは事前にスキーマを読むため、information_schemaの全件が見える権限が要る
✅ # WIFのattribute_conditionでリポジトリを限定する。無いと任意のリポジトリからトークンを引ける
❌ # サービスアカウントを作成する
```

- `depends_on` / `lifecycle` / `ignore_changes` を書いたら**その理由を必ず添える**。宣言だけでは「なぜ通常の依存解決では足りないか」が読めない
- リージョン・マシンタイプ・タイムアウト秒といった直値に選定理由があるなら書く。無いなら書かない

### コメントアウトされたコードを残さない

将来使うかもしれない設定を `#` で寝かせない。gitが持つ。例外は `backend.tf` の接続先のような**利用者が埋めるテンプレート**で、その場合は「何を埋めるか」を明記する。

## スクリプト

`scripts/` のシェルスクリプトは、冒頭に**用途と、必要な権限・実行場所といった前提**をコメントで書く。手元で実行する人が唯一の読み手なので、ここは厚くてよい。
