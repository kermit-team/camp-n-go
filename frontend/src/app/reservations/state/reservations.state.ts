import { Injectable } from '@angular/core';
import { SharedListState } from '../../shared/classes/list.state';
import {
  ReservationDetails,
  ReservationListItem,
} from '../models/reservation.interface';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ReservationsState extends SharedListState<ReservationListItem> {
  private reservationDetails = new BehaviorSubject<ReservationDetails>(
    undefined,
  );

  setReservationDetails(reservationDetails: ReservationDetails) {
    this.reservationDetails.next(reservationDetails);
  }

  selectReservationDetail$() {
    return this.reservationDetails.asObservable();
  }
}
