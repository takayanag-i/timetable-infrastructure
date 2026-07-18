/**
 * ユーザー作成（Create）
 *
 * 使用方法:
 *   node create-user.js <email> <password> [displayName] [schoolId] [roles(カンマ区切り)]
 *
 * 例:
 *   node create-user.js admin@example.com Password123 "Admin User" school-0001 USER,ADMIN
 */

import { init, printUser } from './_lib.js';

const [, , email, password, displayName = 'Test User', schoolId = 'school-0001', rolesArg] = process.argv;
if (!email || !password) {
  console.error('使用方法: node create-user.js <email> <password> [displayName] [schoolId] [roles(カンマ区切り)]');
  process.exit(1);
}
const roles = rolesArg ? rolesArg.split(',') : ['USER'];

const admin = init();
try {
  const user = await admin.auth().createUser({
    email,
    password,
    emailVerified: true,
    displayName,
  });
  await admin.auth().setCustomUserClaims(user.uid, { roles, schoolId });

  console.log('✅ 作成しました');
  printUser(await admin.auth().getUser(user.uid));
} catch (error) {
  console.error('❌', error.message);
  if (error.code === 'auth/email-already-exists') {
    console.error('   既存ユーザーです。クレーム変更は update-user.js を使ってください');
  }
  process.exitCode = 1;
} finally {
  await admin.app().delete();
}
