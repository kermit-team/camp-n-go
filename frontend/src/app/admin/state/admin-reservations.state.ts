import { Injectable } from '@angular/core';
import { SharedListState } from '../../shared/classes/list.state';
import { AdminReservationItem } from '../models/admin-reservations.interface';

@Injectable({
  providedIn: 'root',
})
export class AdminReservationsState extends SharedListState<AdminReservationItem> {}
