import { inject, Injectable } from '@angular/core';
import { RegisterRequest } from '../models/register.interface';
import { AuthApi } from './auth.api';
import { AlertService } from '../../shared/services/alert.service';
import { catchError, first, map, Observable, of, switchMap } from 'rxjs';
import { AuthState } from '../state/auth.state';
import {
  AuthUser,
  LoginRequest,
  LoginTokensResponse,
  UserJwt,
} from '../models/auth.interface';
import { Router } from '@angular/router';
import { jwtDecode } from 'jwt-decode';

const ACCESS_KEY = 'access';
const REFRESH_KEY = 'refresh';
@Injectable({
  providedIn: 'root',
})
export class AuthFacade {
  private authApi = inject(AuthApi);
  private alertService = inject(AlertService);
  private authState = inject(AuthState);
  private router = inject(Router);

  register(registerData: RegisterRequest) {
    this.authApi
      .register(registerData)
      .pipe(first())
      .subscribe({
        next: () =>
          this.alertService.showDialog(
            'Pomyślnie dodano użytkownika',
            'success',
          ),

        error: () =>
          this.alertService.showDialog(
            'Nie udało dodać się użytkownika',
            'error',
          ),
      });
  }

  login(loginData: LoginRequest) {
    this.authApi
      .login(loginData)
      .pipe(
        first(),
        switchMap((tokens: LoginTokensResponse) => {
          this.saveTokens(tokens);
          const decoded = jwtDecode<UserJwt>(tokens.access);
          return this.authApi.getUserInfo(decoded.user_id);
        }),
      )
      .subscribe({
        next: (user: AuthUser) => {
          this.authState.setAuthenticatedUser(user);
          this.router.navigate(['/']);
        },
        error: () =>
          this.alertService.showDialog('Nie udało się zalogować', 'error'),
      });
  }

  getToken(): string {
    return this.authState.getToken();
  }

  saveTokens(tokens: LoginTokensResponse) {
    this.authState.setToken(tokens.access);
    this.authState.setRefreshToken(tokens.refresh);
    localStorage.setItem(ACCESS_KEY, tokens.access);
    localStorage.setItem(REFRESH_KEY, tokens.refresh);
  }

  removeTokens() {
    localStorage.removeItem(ACCESS_KEY);
    localStorage.removeItem(REFRESH_KEY);
  }

  verifyEmail(uid64: string, token: string): Observable<{ verified: boolean }> {
    return this.authApi.verifyEmail(uid64, token).pipe(
      first(),
      map(() => ({ verified: true })),
      catchError(() => of({ verified: false })),
    );
  }

  resendEmail(email: string) {
    this.authApi
      .resentEmail(email)
      .pipe(first())
      .subscribe({
        next: (email: string) => {
          this.alertService.showDialog('Wysłano ponownie email', 'success');
        },
        error: () =>
          this.alertService.showDialog('Nie udało się wysłać emaila', 'error'),
      });
  }

  resetEmail(email: string) {
    this.authApi
      .resetPassword(email)
      .pipe(first())
      .subscribe({
        next: (email: string) => {
          this.alertService.showDialog(
            'Wysłano email z linkiem do resetu',
            'success',
          );
        },
        error: () =>
          this.alertService.showDialog('Nie udało się wysłać emaila', 'error'),
      });
  }

  selectAuthenticated$(): Observable<AuthUser> {
    return this.authState.selectAuthenticatedUser$();
  }

  resetPasswordChange(uid64: string, token: string, password: string) {
    return this.authApi
      .resetPasswordRequest(uid64, token, password)
      .pipe(first())
      .subscribe({
        next: (email: string) => {
          this.alertService.showDialog('Pomyślnie zmieniono hasło', 'success');
        },
        error: () =>
          this.alertService.showDialog('Coś poszło nie tak', 'error'),
      });
  }
}
