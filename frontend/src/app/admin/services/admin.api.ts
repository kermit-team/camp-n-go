import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import {
  AdminUserDetails,
  AdminUsersAddEditRequest,
  AdminUsersItem,
} from '../models/admin-users.interface';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';
import { AdminReservationItem } from '../models/admin-reservations.interface';

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

  getAdminReservationsList(
    parameters: LibListRequestParams,
  ): Observable<LibListItem<AdminReservationItem>> {
    const params = this.convertObjectToHttpParams(parameters);
    return this.httpClient.get<LibListItem<AdminReservationItem>>(
      `http://localhost:8000/api/admin/camping/reservations/`,
      { params },
    );
  }

  getUserGroups(): Observable<LibSelectItem[]> {
    return this.httpClient.get<LibSelectItem[]>(
      `http://localhost:8000/api/admin/accounts/groups/`,
    );
  }

  createUser(
    data: AdminUsersAddEditRequest,
  ): Observable<AdminUsersAddEditRequest> {
    return this.httpClient.post<AdminUsersAddEditRequest>(
      `http://localhost:8000/api/admin/accounts/create/`,
      { ...data },
    );
  }

  editeUser(
    data: AdminUsersAddEditRequest,
    id: string,
  ): Observable<AdminUsersAddEditRequest> {
    return this.httpClient.patch<AdminUsersAddEditRequest>(
      `http://localhost:8000/api/admin/accounts/${id}/modify/`,
      { ...data },
    );
  }

  getUserDetails(identifier: string): Observable<AdminUserDetails> {
    return this.httpClient.get<AdminUserDetails>(
      `http://localhost:8000/api/accounts/${identifier}/`,
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
}
