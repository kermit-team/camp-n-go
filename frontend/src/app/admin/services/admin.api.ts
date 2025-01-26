import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import { AdminUsersItem } from '../models/admin-users.interface';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';

@Injectable({
  providedIn: 'root',
})
export class AdminApi {
  private httpClient = inject(HttpClient);

  getAdminUsersList(
    parameters: LibListRequestParams,
  ): Observable<LibListItem<AdminUsersItem>> {
    const params = this.convertObjectToHttpParams(parameters);
    return this.httpClient.get<LibListItem<AdminUsersItem>>(
      `http://localhost:8000/api/admin/accounts/`,
      { params },
    );
  }

  getUserGroups(): Observable<LibSelectItem[]> {
    return this.httpClient.get<LibSelectItem[]>(
      `http://localhost:8000/api/admin/accounts/groups/`,
    );
  }

  convertObjectToHttpParams(obj: LibListRequestParams): HttpParams {
    let params = new HttpParams();

    params = params.set('page', obj.page);
    params = params.set('page_size', obj.page_size);

    for (const key in obj.filters) {
      if (obj.filters.hasOwnProperty(key)) {
        const value = obj.filters[key];
        if (value !== null && value !== undefined) {
          params = params.set(key, value);
        }
      }
    }

    return params;
  }

  // createReservation(reservation: CreateReservationRequest) {
  //   return this.httpClient.post<CreateReservationResponse>(
  //     `http://localhost:8000/api/camping/reservations/create/`,
  //     { ...reservation },
  //   );
  // }
}
