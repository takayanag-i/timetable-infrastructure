/**
 * Firebase Admin SDK - テストユーザー作成スクリプト
 *
 * 新規ユーザーを作成し、カスタムクレーム（roles: ["USER"], schId）を自動設定します。
 *
 * 使用方法:
 *   node setup-user.js <email> <password> [displayName] [schId]
 *
 * 例:
 *   node setup-user.js test@example.com Password123 "Test User" school-0001
 */

const admin = require('firebase-admin');
const path = require('path');
const os = require('os');

// サービスアカウントキーの読み込み（~/service-account-key.json）
const serviceAccount = require(path.join(os.homedir(), 'service-account-key.json'));

// Firebase Admin SDKの初期化
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'timetable-479003'
});

/**
 * ユーザー作成とカスタムクレーム設定
 */
async function setupUser() {
  const [,, email, password, displayName = 'Test User', schId = 'school-0001'] = process.argv;

  if (!email || !password) {
    console.error('使用方法: node setup-user.js <email> <password> [displayName] [schId]');
    console.error('例:       node setup-user.js test@example.com Password123 "Test User" school-0001');
    process.exit(1);
  }

  try {
    console.log('🚀 Starting user setup...');
    console.log(`   Email: ${email}`);
    console.log('');

    // ユーザー作成
    console.log('📝 Creating user...');
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      emailVerified: true,
      displayName: displayName
    });

    console.log('✅ User created successfully!');
    console.log(`   UID: ${userRecord.uid}`);
    console.log('');

    // カスタムクレーム設定
    console.log('🔐 Setting custom claims...');
    await admin.auth().setCustomUserClaims(userRecord.uid, {
      roles: ['USER'],
      schId: schId
    });

    console.log('✅ Custom claims set successfully!');
    console.log('   roles: ["USER"]');
    console.log(`   schId: "${schId}"`);
    console.log('');

    // 結果表示
    console.log('🎉 Setup completed!');
    console.log('');
    console.log('User Details:');
    console.log('─────────────────────────────────');
    console.log(`UID:      ${userRecord.uid}`);
    console.log(`Email:    ${userRecord.email}`);
    console.log(`Password: ${password}`);
    console.log(`Name:     ${displayName}`);
    console.log(`Roles:    ["USER"]`);
    console.log('─────────────────────────────────');
    console.log('');
    console.log('💡 Next steps:');
    console.log('1. Set environment variables for Firebase authentication');
    console.log('2. Login with the created user credentials');
    console.log('3. Verify JWT token contains "roles" claim');

  } catch (error) {
    console.error('❌ Error:', error.message);
    
    if (error.code === 'auth/email-already-exists') {
      console.error('');
      console.error('💡 Tip: User already exists. Use a different email or delete the existing user.');
    } else if (error.code === 'auth/invalid-email') {
      console.error('');
      console.error('💡 Tip: Invalid email format. Please check the email address.');
    }
    
    process.exit(1);
  } finally {
    // クリーンアップ
    await admin.app().delete();
  }
}

// スクリプト実行
setupUser();
