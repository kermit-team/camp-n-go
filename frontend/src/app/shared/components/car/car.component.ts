import { Component, EventEmitter, inject, Input, Output } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { Car } from '../../../auth/models/auth.interface';
import { switchMap } from 'rxjs';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { AlertService } from '../../services/alert.service';
import { NgClass } from '@angular/common';

@Component({
  selector: 'lib-car',
  standalone: true,
  imports: [ReactiveFormsModule, FormsModule, NgClass],
  templateUrl: './car.component.html',
  styleUrl: './car.component.scss',
})
export class CarComponent {
  @Input() car: Car;
  @Input() selectable = false;
  @Input() selectedCarPlate: string;
  @Output() carDeleted: EventEmitter<string> = new EventEmitter<string>();
  @Output() selectedFired = new EventEmitter<string>();

  private alertService = inject(AlertService);
  private httpClient = inject(HttpClient);
  private authFacade = inject(AuthFacade);

  deleteCar() {
    this.httpClient
      .delete<any>(
        `http://localhost:8000/api/cars/remove-driver/${this.car.registration_plate}/`,
      )
      .pipe(
        switchMap((response: HttpResponse<any>) => {
          const authId = this.authFacade.getAuthenticatedId();
          return this.authFacade.getUserInfo(authId);
        }),
      )
      .subscribe({
        next: () => {
          this.alertService.showDialog('Udało usunąć się samochód', 'success');
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało usunąć się samochodu',
            'error',
          );
        },
      });
  }

  carSelected() {
    this.selectedFired.emit(this.car.registration_plate);
  }
}
