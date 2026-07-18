/**
 * ユーザー削除（Delete）
 *
 * 使用方法:
 *   node delete-user.js <uid|email>        … 対象を表示するだけ（dry-run）
 *   node delete-user.js <uid|email> --yes  … 削除を実行
 */

import { init, resolveUser, printUser } from './_lib.js';

const [, , idOrEmail, flag] = process.argv;
if (!idOrEmail) {
  console.error('使用方法: node delete-user.js <uid|email> [--yes]');
  process.exit(1);
}

const admin = init();
try {
  const user = await resolveUser(admin.auth(), idOrEmail);
  printUser(user);

  if (flag !== '--yes') {
    console.log('\n削除するには --yes を付けて再実行してください（元に戻せません）');
  } else {
    await admin.auth().deleteUser(user.uid);
    console.log('✅ 削除しました');
  }
} catch (error) {
  console.error('❌', error.message);
  process.exitCode = 1;
} finally {
  await admin.app().delete();
}
