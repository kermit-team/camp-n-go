import { Component, inject, OnDestroy, OnInit } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { ParcelsFacade } from '../../services/parcels.facade';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { AsyncPipe } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { CarComponent } from '../../../shared/components/car/car.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { DateFormatPipe } from '../../../shared/pipes/date.pipe';
import { ParcelToReserve } from '../../models/parcels.interface';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-reservation-create',
  standalone: true,
  templateUrl: './reservation-create.component.html',
  styleUrl: './reservation-create.component.scss',
  imports: [
    ReactiveFormsModule,
    AsyncPipe,
    RouterLink,
    CarComponent,
    ButtonComponent,
    DateFormatPipe,
  ],
})
export class ReservationCreateComponent implements OnInit, OnDestroy {
  private parcelFacade = inject(ParcelsFacade);
  private authFacade = inject(AuthFacade);
  private router = inject(Router);

  authenticated$ = this.authFacade.selectAuthenticated$();
  parcelToReserve$ = this.parcelFacade.selectParcelForReservation$();

  selectedCar: number;

  private subscription: Subscription;

  ngOnInit() {
    this.subscription = this.parcelToReserve$.subscribe((parcel) => {
      if (!parcel) {
        this.router.navigate(['/parcels/search']);
      }
    });
  }

  maskIdCard(id_card: string): string {
    if (!id_card) {
      return '';
    }
    const start = id_card.slice(0, 2);
    const end = id_card.slice(-2);
    const masked = '*'.repeat(id_card.length - 4);

    return `${start}${masked}${end}`;
  }

  selectCar(id: number) {
    this.selectedCar = id;
  }

  calculateNights(
    startDate: Date | string | number,
    endDate: Date | string | number,
  ): number {
    const start = new Date(startDate);
    const end = new Date(endDate);

    start.setHours(0, 0, 0, 0);
    end.setHours(0, 0, 0, 0);

    const diffInMs = end.getTime() - start.getTime();
    const diffInDays = Math.floor(diffInMs / (1000 * 60 * 60 * 24));

    return diffInDays;
  }

  goToReservationList() {
    this.router.navigate([`/parcels/search`]);
  }

  createReservation(parcel: ParcelToReserve) {
    this.parcelFacade.reserveParcel({
      date_from: new Date(parcel.date_from).toISOString().slice(0, 10),
      date_to: new Date(parcel.date_to).toISOString().slice(0, 10),
      number_of_adults: parcel.number_of_adults,
      number_of_children: parcel.number_of_children,
      car: this.selectedCar,
      camping_plot: parcel.id,
    });
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
