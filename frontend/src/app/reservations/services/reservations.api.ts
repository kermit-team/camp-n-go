import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import {
  ReservationChangeCar,
  ReservationDetails,
  ReservationListItem,
} from '../models/reservation.interface';

@Injectable({
  providedIn: 'root',
})
export class ReservationsApi {
  private httpClient = inject(HttpClient);

  getReservationsList(
    parameters: LibListRequestParams,
  ): Observable<LibListItem<ReservationListItem>> {
    const params = this.convertObjectToHttpParams(parameters);
    return this.httpClient.get<LibListItem<ReservationListItem>>(
      `http://localhost:8000/api/camping/reservations/`,
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

  cancelReservation(id: number) {
    return this.httpClient.patch(
      `http://localhost:8000/api/camping/reservations/${id}/cancel/`,
      {},
    );
  }

  getReservationInfo(id: number) {
    return this.httpClient.get<ReservationDetails>(
      `http://localhost:8000/api/camping/reservations/${id}/details/`,
    );
  }

  modifyReservation(data: ReservationChangeCar) {
    return this.httpClient.put<{ car: number }>(
      `http://localhost:8000/api/camping/reservations/${data.reservationId}/modify/car/`,
      { car: data.carId },
    );
  }
}
