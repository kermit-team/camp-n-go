import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  Parcel,
  ParcelToReserve,
  PassedData,
} from '../models/parcels.interface';
import { SharedListState } from '../../shared/classes/list.state';

@Injectable({
  providedIn: 'root',
})
export class ParcelsState extends SharedListState<Parcel> {
  private parcelDatePeople$ = new BehaviorSubject<PassedData>(undefined);
  private parcelForReservation$ = new BehaviorSubject<ParcelToReserve>(
    undefined,
  );

  setParcelDatePeople$(data: PassedData) {
    this.parcelDatePeople$.next(data);
  }

  selectParcelDatePeople$() {
    return this.parcelDatePeople$.asObservable();
  }

  setParcelForReservation$(data: ParcelToReserve) {
    this.parcelForReservation$.next(data);
  }

  selectParcelForReservation$() {
    return this.parcelForReservation$.asObservable();
  }
}
