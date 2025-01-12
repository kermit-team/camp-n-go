import { Component, inject } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { ParcelsFacade } from '../../services/parcels.facade';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { AsyncPipe } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CarComponent } from '../../../shared/components/car/car.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';

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
  ],
})
export class ReservationCreateComponent {
  private parcelFacade = inject(ParcelsFacade);
  private authFacade = inject(AuthFacade);

  authenticated$ = this.authFacade.selectAuthenticated$();

  selectedCar: string;

  maskIdCard(id_card: string): string {
    if (!id_card) {
      return '';
    }
    const start = id_card.slice(0, 2);
    const end = id_card.slice(-2);
    const masked = '*'.repeat(id_card.length - 4);

    return `${start}${masked}${end}`;
  }

  selectCar(plate: string) {
    this.selectedCar = plate;
  }
}
