/**
 * ユーザー照会（Read）
 *
 * 使用方法:
 *   node get-user.js <uid|email>              … 1ユーザーの詳細
 *   node get-user.js --school-id <schoolId>   … 学校単位の一覧
 */

import { init, resolveUser, printUser } from './_lib.js';

const [, , arg1, arg2] = process.argv;
if (!arg1) {
  console.error('使用方法: node get-user.js <uid|email> | --school-id <schoolId>');
  process.exit(1);
}

const admin = init();
try {
  if (arg1 === '--school-id') {
    if (!arg2) {
      console.error('使用方法: node get-user.js --school-id <schoolId>');
      process.exit(1);
    }
    const { users } = await admin.auth().listUsers(1000);
    const matched = users.filter(u => u.customClaims?.schoolId === arg2);
    for (const u of matched) {
      console.log(
        [
          u.uid,
          (u.email ?? '-').padEnd(40),
          JSON.stringify(u.customClaims?.roles ?? []),
        ].join('  ')
      );
    }
    console.log(`--- ${matched.length}件 (schoolId=${arg2})`);
  } else {
    printUser(await resolveUser(admin.auth(), arg1));
  }
} catch (error) {
  console.error('❌', error.message);
  process.exitCode = 1;
} finally {
  await admin.app().delete();
}
