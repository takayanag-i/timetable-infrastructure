# Identity Platform ユーザー管理スクリプト

sandboxのIdentity Platformユーザーを直接操作するCRUDスクリプト。

通常のメンバー管理は本番UIの `/members`（UCP05、ADMIN専用）で行う。本スクリプトの用途は
**最初のADMINを作るブートストラップ**と、**UIが使えないときの非常口**（ユースケース: 本体リポジトリの「UCP06 アカウント運用」）。

## 前提

- `~/service-account-key.json` に管理用サービスアカウントキーを配置
- `npm install` 済み

## コマンド

```bash
# Create: ユーザー作成（クレーム込み）
node create-user.js <email> <password> [displayName] [schoolId] [roles(カンマ区切り)]
node create-user.js admin@example.com Password123 "Admin" school-0001 USER,ADMIN

# Read: 詳細（uidまたはemail） / 学校単位の一覧
node get-user.js sandbox-kobe-user@timetable-app.com
node get-user.js --school-id school-0001

# Update: 指定項目のみ更新（クレームは既存とマージ）
node update-user.js <uid|email> [--roles USER,ADMIN] [--school-id school-0001] \
                                [--display-name "名前"] [--password 新パスワード]

# Delete: 引数だけならdry-run（対象表示のみ）、--yesで実行
node delete-user.js <uid|email>
node delete-user.js <uid|email> --yes
```

## 注意

- クレーム（`roles` / `schoolId`）の変更は**対象ユーザーの再ログインまで反映されない**
- `schoolId` クレームが無いユーザーは認可がfail-closedになり、アプリで何も見えない
