import { DestroyRef, inject, Injectable } from '@angular/core';
import {
  CreateReservationRequest,
  CreateReservationResponse,
  ParcelListItem,
  ParcelSearchFilters,
  ParcelToReserve,
  PassedData,
} from '../models/parcels.interface';
import { ParcelsState } from '../state/parcels.state';
import { catchError, first, of, switchMap } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import { ParcelsApi } from './parcels.api';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { AlertService } from '../../shared/services/alert.service';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class ParcelsFacade {
  private parcelsState = inject(ParcelsState);
  private parcelsApi = inject(ParcelsApi);
  private alertService = inject(AlertService);
  private router = inject(Router);

  setPassedData(passedData: PassedData) {
    localStorage.setItem('passedData', JSON.stringify(passedData));
  }

  getPassedData(): PassedData {
    const data = localStorage.getItem('passedData');
    return data ? JSON.parse(data) : null;
  }

  getDataTransformedPassedData() {
    return {
      number_of_adults: this.getPassedData().adultNumber,
      number_of_children: this.getPassedData().childrenNumber,
      date_to: new Date(this.getPassedData().endDate)
        .toISOString()
        .slice(0, 10),
      date_from: new Date(this.getPassedData().startDate)
        .toISOString()
        .slice(0, 10),
    };
  }

  loadParcelsItems(destroyRef: DestroyRef) {
    const passedData = this.getDataTransformedPassedData();
    this.selectParcelListParams$()
      .pipe(
        switchMap((params: LibListRequestParams) =>
          this.parcelsApi
            .getParcelList({ filters: passedData, ...params })
            .pipe(
              catchError((error: Error) =>
                of({
                  page: 0,
                  count: 0,
                  results: [],
                }),
              ),
            ),
        ),
        takeUntilDestroyed(destroyRef),
      )
      .subscribe({
        next: (response: LibListItem<ParcelListItem>) => {
          this.parcelsState.setItems(response.results);
          this.parcelsState.setPaginationMetadata({
            currentPage: response.page,
            totalElements: response.count,
            currentLimit: 10,
          });
        },
        error: () => {
          this.parcelsState.setItems([]);
        },
      });
  }

  selectParcelItems$() {
    return this.parcelsState.selectItems$();
  }

  selectParcelListParams$() {
    return this.parcelsState.selectListRequestParameters$();
  }

  selectParcelPaginationMetadata$() {
    return this.parcelsState.selectPaginationMetadata$();
  }

  setParcelPage(newPage: number) {
    this.parcelsState.setPage(newPage);
  }

  selectParcelFilters$() {
    return this.parcelsState.selectFilters$();
  }

  setParcelFilters(filters: ParcelSearchFilters) {
    this.parcelsState.setListFilters(filters);
  }

  reserveParcel(reserveData: CreateReservationRequest) {
    this.parcelsApi
      .createReservation(reserveData)
      .pipe(first())
      .subscribe({
        next: (response: CreateReservationResponse) => {
          window.location.href = response.checkout_url;
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało się utworzyć rezerwacji',
            'error',
          );
        },
      });
  }

  setParcelForReservation(data: ParcelToReserve) {
    this.parcelsState.setParcelForReservation$(data);
  }

  selectParcelForReservation$() {
    return this.parcelsState.selectParcelForReservation$();
  }
}
