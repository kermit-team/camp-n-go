import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RegisterRequest } from '../models/register.interface';

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
}
