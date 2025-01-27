import { inject, Injectable } from '@angular/core';
import { UtilService } from '../../shared/services/util.service';
import { ProfileApi } from './profile.api';
import { switchMap, throwError } from 'rxjs';
import { AuthFacade } from '../../auth/services/auth.facade';
import { catchError } from 'rxjs/operators';
import { ProfileEdit } from '../models/profile.interface';

@Injectable({
  providedIn: 'root',
})
export class ProfileFacade {
  private profileApi = inject(ProfileApi);
  private authFacade = inject(AuthFacade);
  private alertService = inject(UtilService);

  addCar(registration_plate: string) {
    this.profileApi
      .addCar(registration_plate)
      .pipe(
        switchMap((res) => {
          const authId = this.authFacade.getAuthenticatedId();
          return this.authFacade.getUserInfo(authId);
        }),
        catchError((error) => {
          return throwError(() => error);
        }),
      )
      .subscribe({
        next: (res) => {
          this.alertService.showDialog('Poprawnie dodano samochód', 'success');
        },
        error: () =>
          this.alertService.showDialog(
            'Nie udało dodać się samochodu',
            'error',
          ),
      });
  }

  editProfile(profileData: ProfileEdit) {
    const authId = this.authFacade.getAuthenticatedId();
    this.profileApi
      .editProfile(profileData, authId)
      .pipe(
        switchMap((res) => {
          return this.authFacade.getUserInfo(authId);
        }),
        catchError((error) => {
          return throwError(() => error);
        }),
      )
      .subscribe({
        next: (res) => {
          this.alertService.showDialog('Zmieniono dane', 'success');
        },
        error: () =>
          this.alertService.showDialog('Nie udało się zmienić danych', 'error'),
      });
  }
}
