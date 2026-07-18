/**
 * 共通処理: Admin SDK初期化とユーザー解決
 */

import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { homedir } from 'node:os';
import admin from 'firebase-admin';

export function init() {
  const serviceAccount = JSON.parse(
    readFileSync(join(homedir(), 'service-account-key.json'), 'utf-8')
  );
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: 'timetable-479003',
  });
  return admin;
}

/** uidまたはemailでユーザーを取得する */
export async function resolveUser(auth, idOrEmail) {
  return idOrEmail.includes('@')
    ? auth.getUserByEmail(idOrEmail)
    : auth.getUser(idOrEmail);
}

export function printUser(user) {
  console.log('uid          :', user.uid);
  console.log('email        :', user.email);
  console.log('displayName  :', user.displayName ?? '-');
  console.log('customClaims :', JSON.stringify(user.customClaims ?? {}));
  console.log('disabled     :', user.disabled);
  console.log('lastSignIn   :', user.metadata.lastSignInTime ?? '-');
}
