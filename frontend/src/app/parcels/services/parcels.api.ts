import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import {
  Parcel,
  ParcelListItem,
  ReserveParcel,
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

  getParcelDetail(data: ReserveParcel): Observable<Parcel> {
    return of({
      camping_section: {
        name: 'A',
        base_price: '400.00',
        price_per_adult: '50.00',
        price_per_child: '25.00',
      },
      base_price: '400.00',
      name: 'A',
      price_per_adult: '50.00',
      price_per_child: '25.00',
      description: 'Parcel premium w sekcji A',
      electricity_connection: true,
      grey_water_discharge: true,
      is_shaded: true,
      length: '5.00',
      max_number_of_people: 10,
      position: '1',
      water_connection: true,
      width: '10.00',
    });
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
}
