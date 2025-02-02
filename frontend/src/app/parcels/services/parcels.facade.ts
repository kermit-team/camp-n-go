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
import { UtilService } from '../../shared/services/util.service';
import { Router } from '@angular/router';
import { ContactRequest } from '../../landing-page/models/contact.interface';

@Injectable({
  providedIn: 'root',
})
export class ParcelsFacade {
  private parcelsState = inject(ParcelsState);
  private parcelsApi = inject(ParcelsApi);
  private alertService = inject(UtilService);
  private router = inject(Router);

  setPassedData(passedData: PassedData) {
    localStorage.setItem('passedData', JSON.stringify(passedData));
  }

  getPassedData(): PassedData {
    const data = localStorage.getItem('passedData');
    return data ? JSON.parse(data) : null;
  }

  getDataTransformedPassedData() {
    console.log(this.getPassedData().endDate);
    return {
      number_of_adults: this.getPassedData().adultNumber,
      number_of_children: this.getPassedData().childrenNumber,
      date_to: this.getPassedData().endDate,
      date_from: this.getPassedData().startDate,
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

  sendContact(data: ContactRequest) {
    this.parcelsApi
      .contact(data)
      .pipe(first())
      .subscribe({
        next: (response: ContactRequest) => {
          this.alertService.showDialog('Wysłano email', 'success');
        },
        error: () => {
          this.alertService.showDialog('Nie udało się wysłać emaila', 'error');
        },
      });
  }
}
