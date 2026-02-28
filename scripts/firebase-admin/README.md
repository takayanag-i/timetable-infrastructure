# AUSC0001

テストユーザーを作成し、カスタムクレームを設定する。

## 前提条件

- Identity Platformが有効化されていること
- Node.js、パッケージがインストールされていること
- 管理用サービスアカウントのキーが `~/service-account-key.json` として配置されていること

## Firebase Admin SDK

```bash
# テストユーザー作成 + カスタムクレーム設定
# 引数: <email> <password> [displayName]
node setup-user.js test@example.com yourSecurePassword123 "Test User"
```

実行結果:
```
🚀 Starting user setup...
   Email: test@example.com

📝 Creating user...
✅ User created successfully!
   UID: AbCd1234EfGh5678IjKl

🔐 Setting custom claims...
✅ Custom claims set successfully!
   roles: ["USER"]

🎉 Setup completed!

User Details:
─────────────────────────────────
UID:      AbCd1234EfGh5678IjKl
Email:    test@example.com
Password: yourSecurePassword123
Name:     Test User
Roles:    ["USER"]
─────────────────────────────────
```

## トークンの確認

設定したユーザーでログインし、JWTトークンを確認します。

### フロントエンドでのログイン

1. 環境変数を設定：
   ```bash
   export NEXT_PUBLIC_AUTH_PROVIDER=firebase
   export NEXT_PUBLIC_FIREBASE_API_KEY=YOUR_API_KEY
   export NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=timetable-479003.firebaseapp.com
   export NEXT_PUBLIC_FIREBASE_PROJECT_ID=timetable-479003
   ```

2. フロントエンドを起動
3. ログイン画面で作成したユーザーの認証情報を入力

### JWTトークンのデコード

ログイン後、ブラウザの開発者ツールで取得したJWTトークンを [jwt.io](https://jwt.io/) でデコードし、`roles` クレームが含まれていることを確認します。

期待される内容：
```json
{
  "sub": "AbCd1234EfGh5678IjKl",
  "email": "test@example.com",
  "email_verified": true,
  "roles": ["USER"],
  "iss": "https://securetoken.google.com/timetable-479003",
  "aud": "timetable-479003",
  "exp": 1708012800,
  "iat": 1708009200
}
```
