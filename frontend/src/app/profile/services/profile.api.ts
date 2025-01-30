import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ProfileEdit } from '../models/profile.interface';
import { Profile } from '../../auth/models/auth.interface';

@Injectable({
  providedIn: 'root',
})
export class ProfileApi {
  private httpClient = inject(HttpClient);

  addCar(registration_plate: string) {
    return this.httpClient.post<string>(`http://localhost:8000/api/cars/add/`, {
      registration_plate,
    });
  }

  editProfile(profileData: ProfileEdit, accountId: string) {
    return this.httpClient.patch<Profile>(
      `http://localhost:8000/api/accounts/${accountId}/modify/`,
      { ...profileData },
    );
  }

  anonimise(id: string) {
    return this.httpClient.delete<string>(
      `http://localhost:8000/api/accounts/${id}/anonymize/`,
    );
  }
}
