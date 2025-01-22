import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import {
  ReservationChangeCar,
  ReservationDetails,
} from '../../models/reservation.interface';
import { DateFormatPipe } from '../../../shared/pipes/date.pipe';
import { RouterLink } from '@angular/router';
import { CarComponent } from '../../../shared/components/car/car.component';
import { AuthUser } from '../../../auth/models/auth.interface';
import { ButtonComponent } from '../../../shared/components/button/button.component';

@Component({
  selector: 'app-reservation-edit-content',
  standalone: true,
  templateUrl: './reservation-edit-content.component.html',
  styleUrl: './reservation-edit-content.component.scss',
  imports: [
    ReactiveFormsModule,
    DateFormatPipe,
    RouterLink,
    CarComponent,
    ButtonComponent,
  ],
})
export class ReservationEditContentComponent implements OnInit {
  @Input() reservationDetails: ReservationDetails;
  @Input() user: AuthUser;

  @Output() cancelFired = new EventEmitter<void>();
  @Output() changeCarFired = new EventEmitter<ReservationChangeCar>();

  selectedCar: number;

  ngOnInit() {
    this.selectedCar = this.reservationDetails.car.id;
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

  cancel() {
    this.cancelFired.emit();
  }

  save() {
    this.changeCarFired.emit({
      carId: this.selectedCar,
      reservationId: this.reservationDetails.id,
    });
  }
}
