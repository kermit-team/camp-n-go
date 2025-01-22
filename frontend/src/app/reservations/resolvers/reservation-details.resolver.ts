import { inject } from '@angular/core';
import { ResolveFn } from '@angular/router';
import { EMPTY, mergeMap, of, take } from 'rxjs';
import { ReservationDetails } from '../models/reservation.interface';
import { ReservationsFacade } from '../services/reservations.facade';

export const reservationDetailsResolver: ResolveFn<ReservationDetails> = (
  route,
) => {
  const reservationsFacade = inject(ReservationsFacade);
  const id = +route.paramMap.get('id');

  return reservationsFacade.getReservationInfo(id).pipe(
    take(1),
    mergeMap((data) => {
      if (data) {
        return of(data);
      } else {
        return EMPTY;
      }
    }),
  );
};
