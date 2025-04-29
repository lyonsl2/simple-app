import { Injectable } from '@nestjs/common';
import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { Auth, getAuth } from 'firebase-admin/auth';

const serviceAccount = require('../../secrets/serviceAccountKey.json');

@Injectable()
export class AuthService {
  private auth: Auth;

  constructor() {
    const apps = getApps();
    if (apps.length === 0) {
      const app = initializeApp({
        credential: cert(serviceAccount),
      });
      this.auth = getAuth(app);
    } else {
      this.auth = getAuth(apps[0]);
    }
  }

  async verifyAndDecodeToken(idToken: string) {
    return this.auth.verifyIdToken(idToken);
  }
}
