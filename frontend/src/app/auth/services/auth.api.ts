import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RegisterRequest } from '../models/register.interface';
import {
  AuthUser,
  LoginRequest,
  LoginTokensResponse,
} from '../models/auth.interface';
import { Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthApi {
  private httpClient = inject(HttpClient);

  register(registerData: RegisterRequest) {
    return this.httpClient.post<RegisterRequest>(
      `http://localhost:8000/api/accounts/register/`,
      {
        ...registerData,
      },
    );
  }

  login(loginData: LoginRequest) {
    return this.httpClient.post<LoginTokensResponse>(
      `http://localhost:8000/api/accounts/token/`,
      {
        ...loginData,
      },
    );
  }

  verifyEmail(uid64: string, token: string) {
    return this.httpClient.get<void>(
      `http://localhost:8000/api/accounts/email-verification/${uid64}/${token}/`,
    );
  }

  resentEmail(email: string) {
    return this.httpClient.post<string>(
      `http://localhost:8000/api/accounts/email-verification/resend/`,
      { email },
    );
  }

  getUserInfo(id: number): Observable<AuthUser> {
    return of({
      name: 'Andrzej',
      surname: 'Pimpusiowy',
      email: 'Andrzej@gmail.com',
      isAdmin: true,
    });
  }

  resetPassword(email: string) {
    return this.httpClient.post<string>(
      `http://localhost:8000/api/accounts/password-reset/`,
      email,
    );
  }

  resetPasswordRequest(uid64: string, token: string, password: string) {
    return this.httpClient.post<string>(
      `http://localhost:8000/api/accounts/password-reset/confirm/${uid64}/${token}/`,
      { password },
    );
  }
}
