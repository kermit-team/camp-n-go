import { Component, EventEmitter, inject, Input, Output } from '@angular/core';
import { CarComponent } from '../../../shared/components/car/car.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { MatDialog } from '@angular/material/dialog';
import { ProfileBaseDialogComponent } from '../profile-base-dialog/profile-base-dialog.component';
import { Car } from '../../../auth/models/auth.interface';

@Component({
  selector: 'app-profile-cars',
  standalone: true,
  imports: [CarComponent, ButtonComponent],
  templateUrl: './profile-cars.component.html',
  styleUrl: './profile-cars.component.scss',
})
export class ProfileCarsComponent {
  @Input() cars: Array<Car>;
  @Output() carAdded = new EventEmitter<string>();

  private dialog = inject(MatDialog);

  addCar() {
    const dialogRef = this.dialog.open(ProfileBaseDialogComponent, {
      width: '350px',
      data: { titleCustom: 'Wpisz numer rejestracyjny' },
    });

    dialogRef.componentInstance.formSaved.subscribe((result) => {
      this.carAdded.emit(result.dataToEdit);
    });
  }
}
