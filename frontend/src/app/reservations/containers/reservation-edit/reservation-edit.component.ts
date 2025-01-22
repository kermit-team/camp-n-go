import { Component, inject } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ReservationsFacade } from '../../services/reservations.facade';
import { ReservationEditContentComponent } from '../../components/reservation-edit-content/reservation-edit-content.component';
import { AsyncPipe } from '@angular/common';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { ReservationChangeCar } from '../../models/reservation.interface';

@Component({
  selector: 'app-reservation-create',
  standalone: true,
  templateUrl: './reservation-edit.component.html',
  styleUrl: './reservation-edit.component.scss',
  imports: [ReactiveFormsModule, ReservationEditContentComponent, AsyncPipe],
})
export class ReservationEditComponent {
  private reservationsFacade = inject(ReservationsFacade);
  private authFacade = inject(AuthFacade);
  private router = inject(Router);

  reservationDetails$ = this.reservationsFacade.selectReservationDetails$();
  authenticated$ = this.authFacade.selectAuthenticated$();

  cancel() {
    this.router.navigate([`/reservations`]);
  }

  changeCar(data: ReservationChangeCar) {
    this.reservationsFacade.modifyReservation(data);
  }
}
