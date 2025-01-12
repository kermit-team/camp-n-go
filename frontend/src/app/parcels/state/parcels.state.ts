import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Parcel, PassedData } from '../models/parcels.interface';
import { SharedListState } from '../../shared/classes/list.state';

@Injectable({
  providedIn: 'root',
})
export class ParcelsState extends SharedListState<Parcel> {
  private parcelDatePeople$ = new BehaviorSubject<PassedData>(undefined);

  setParcelDatePeople$(data: PassedData) {
    this.parcelDatePeople$.next(data);
  }

  selectParcelDatePeople$() {
    return this.parcelDatePeople$.asObservable();
  }
}
