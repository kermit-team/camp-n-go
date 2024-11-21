import { inject, Injectable } from '@angular/core';
import { RegisterRequest } from '../models/register.interface';
import { AuthApi } from './auth.api';
import { AlertService } from '../../shared/services/alert.service';
import { first } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthFacade {
  private authApi = inject(AuthApi);
  private alertService = inject(AlertService);

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
}
