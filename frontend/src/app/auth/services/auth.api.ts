import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RegisterRequest } from '../models/register.interface';
import { LoginRequest, LoginTokensResponse } from '../models/auth.interface';

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
}
