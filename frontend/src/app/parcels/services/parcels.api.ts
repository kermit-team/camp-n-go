import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import {
  CreateReservationRequest,
  CreateReservationResponse,
  ParcelListItem,
} from '../models/parcels.interface';

@Injectable({
  providedIn: 'root',
})
export class ParcelsApi {
  private httpClient = inject(HttpClient);

  getParcelList(
    parameters: LibListRequestParams,
  ): Observable<LibListItem<ParcelListItem>> {
    const params = this.convertObjectToHttpParams(parameters);
    return this.httpClient.get<LibListItem<ParcelListItem>>(
      `http://localhost:8000/api/camping/plots/available/`,
      { params },
    );
  }

  convertObjectToHttpParams(obj: LibListRequestParams): HttpParams {
    let params = new HttpParams();

    params = params.set('page', obj.page);
    params = params.set('page_size', obj.page_size);

    for (const key in obj.filters) {
      if (obj.filters.hasOwnProperty(key)) {
        params = params.set(key, obj.filters[key]);
      }
    }

    return params;
  }

  createReservation(reservation: CreateReservationRequest) {
    return this.httpClient.post<CreateReservationResponse>(
      `http://localhost:8000/api/camping/reservations/create/`,
      { ...reservation },
    );
  }
}
