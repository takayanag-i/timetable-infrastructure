/**
 * ユーザー更新（Update）
 *
 * 使用方法:
 *   node update-user.js <uid|email> [--roles USER,ADMIN] [--school-id school-0001]
 *                                   [--display-name "名前"] [--password 新パスワード]
 *
 * 指定した項目だけを更新する。クレーム（roles / schoolId）は既存クレームとマージする。
 * クレームの反映には対象ユーザーの再ログインが必要。
 */

import { init, resolveUser, printUser } from './_lib.js';

function parseArgs(argv) {
  const [idOrEmail, ...rest] = argv;
  const opts = {};
  for (let i = 0; i < rest.length; i += 2) {
    const key = rest[i];
    const value = rest[i + 1];
    if (!key?.startsWith('--') || value === undefined) return null;
    opts[key.slice(2)] = value;
  }
  return { idOrEmail, opts };
}

const parsed = parseArgs(process.argv.slice(2));
if (!parsed?.idOrEmail || Object.keys(parsed.opts).length === 0) {
  console.error(
    '使用方法: node update-user.js <uid|email> [--roles USER,ADMIN] [--school-id x] [--display-name x] [--password x]'
  );
  process.exit(1);
}
const { idOrEmail, opts } = parsed;

const admin = init();
try {
  const user = await resolveUser(admin.auth(), idOrEmail);
  console.log('--- before ---');
  printUser(user);

  if (opts['display-name'] || opts.password) {
    await admin.auth().updateUser(user.uid, {
      ...(opts['display-name'] && { displayName: opts['display-name'] }),
      ...(opts.password && { password: opts.password }),
    });
  }

  if (opts.roles || opts['school-id']) {
    const claims = { ...(user.customClaims ?? {}) };
    if (opts.roles) claims.roles = opts.roles.split(',');
    if (opts['school-id']) claims.schoolId = opts['school-id'];
    await admin.auth().setCustomUserClaims(user.uid, claims);
  }

  console.log('--- after ---');
  printUser(await admin.auth().getUser(user.uid));
  console.log('✅ 更新しました（クレーム変更は再ログインで反映）');
} catch (error) {
  console.error('❌', error.message);
  process.exitCode = 1;
} finally {
  await admin.app().delete();
}
