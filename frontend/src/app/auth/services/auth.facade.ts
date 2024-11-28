import { inject, Injectable } from '@angular/core';
import { RegisterRequest } from '../models/register.interface';
import { AuthApi } from './auth.api';
import { AlertService } from '../../shared/services/alert.service';
import { first } from 'rxjs';
import { AuthState } from '../state/auth.state';
import { LoginRequest, LoginTokensResponse } from '../models/auth.interface';
import { Router } from '@angular/router';

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
      .pipe(first())
      .subscribe({
        next: (tokens: LoginTokensResponse) => {
          this.saveTokens(tokens);
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
}
