import { DestroyRef, inject, Injectable } from '@angular/core';
import { ReservationsState } from '../state/reservations.state';
import { catchError, first, of, switchMap, tap } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import { ReservationsApi } from './reservations.api';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { AlertService } from '../../shared/services/alert.service';
import { Router } from '@angular/router';
import {
  ReservationChangeCar,
  ReservationDetails,
  ReservationListItem,
} from '../models/reservation.interface';

@Injectable({
  providedIn: 'root',
})
export class ReservationsFacade {
  private reservationsState = inject(ReservationsState);
  private reservationsApi = inject(ReservationsApi);
  private alertService = inject(AlertService);
  private router = inject(Router);

  loadReservationsItems(destroyRef: DestroyRef) {
    this.selectReservationsListParams$()
      .pipe(
        switchMap((params: LibListRequestParams) =>
          this.reservationsApi.getReservationsList({ ...params }).pipe(
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
        next: (response: LibListItem<ReservationListItem>) => {
          this.reservationsState.setItems(response.results);
          this.reservationsState.setPaginationMetadata({
            currentPage: response.page,
            totalElements: response.count,
            currentLimit: 10,
          });
        },
        error: () => {
          this.reservationsState.setItems([]);
        },
      });
  }

  selectReservationsItems$() {
    return this.reservationsState.selectItems$();
  }

  selectReservationsListParams$() {
    return this.reservationsState.selectListRequestParameters$();
  }

  selectReservationsPaginationMetadata$() {
    return this.reservationsState.selectPaginationMetadata$();
  }

  setReservationsPage(newPage: number) {
    this.reservationsState.setPage(newPage);
  }

  refreshReservationsParamaters() {
    this.reservationsState.refreshListRequestParameters();
  }

  cancelReservation(id: number) {
    this.reservationsApi
      .cancelReservation(id)
      .pipe(first())
      .subscribe({
        next: () => {
          this.alertService.showDialog(
            'Rezerwacja została pomyślnie anulowana',
            'success',
          );
          this.refreshReservationsParamaters();
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało odwołać się rezerwacji',
            'error',
          );
        },
      });
  }

  getReservationInfo(id: number) {
    return this.reservationsApi.getReservationInfo(id).pipe(
      first(),
      catchError(() => {
        this.alertService.showDialog(
          'Nie udało się pobrać danych rezerwacji',
          'error',
        );
        return of(undefined);
      }),
      tap((details: ReservationDetails) => {
        this.reservationsState.setReservationDetails(details);
      }),
    );
  }

  selectReservationDetails$() {
    return this.reservationsState.selectReservationDetail$();
  }

  modifyReservation(data: ReservationChangeCar) {
    this.reservationsApi
      .modifyReservation(data)
      .pipe(first())
      .subscribe({
        next: () => {
          this.router.navigate(['/reservations']).then(() => {
            this.alertService.showDialog(
              'Poprawnie zmodyfikowana rezerwację',
              'success',
            );
          });
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało zmodyfikować się rezerwacji',
            'error',
          );
        },
      });
  }
}
