import { Injectable } from '@angular/core';
import { AuthFacade } from './auth/services/auth.facade';
import { first, tap } from 'rxjs';
import { AuthUser, UserJwt } from './auth/models/auth.interface';
import { jwtDecode } from 'jwt-decode';

@Injectable({ providedIn: 'root' })
export class AppInitializerService {
  constructor(private authFacade: AuthFacade) {}

  initializeApp(): Promise<void> {
    const token = this.authFacade.getTokenFromStorage();
    if (!token) {
      return Promise.resolve();
    }
    const decoded = jwtDecode<UserJwt>(token);
    return this.authFacade
      .getUserInfo(decoded.user_identifier)
      .pipe(
        first(),
        tap({
          next: (user: AuthUser) => {
            this.authFacade.setAuthenticatedUser(user);
          },
          error: (err) => {
            console.error('Token validation failed:', err);
          },
        }),
      )
      .toPromise()
      .then(() => undefined);
  }
}
