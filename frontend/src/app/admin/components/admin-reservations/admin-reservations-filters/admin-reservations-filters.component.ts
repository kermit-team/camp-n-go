import { Component, EventEmitter, inject, Output } from '@angular/core';
import { ButtonComponent } from '../../../../shared/components/button/button.component';
import { InputComponent } from '../../../../shared/components/input/input.component';
import { FormBuilder, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { DatepickerComponent } from '../../../../shared/components/datepicker/datepicker/datepicker.component';
import { AdminReservationFilters } from '../../../models/admin-reservations.interface';
import moment from 'moment';

@Component({
  selector: 'app-admin-reservations-filters',
  standalone: true,
  imports: [
    ButtonComponent,
    InputComponent,
    ReactiveFormsModule,
    DatepickerComponent,
  ],
  templateUrl: './admin-reservations-filters.component.html',
  styleUrl: './admin-reservations-filters.component.scss',
})
export class AdminReservationsFiltersComponent {
  @Output() public searchFired = new EventEmitter<AdminReservationFilters>();

  private fb = inject(FormBuilder);

  form: FormGroup;

  constructor() {
    this.form = this.fb.group({
      date_from: undefined,
      date_to: undefined,
      reservation_data: undefined,
    });
  }

  search() {
    const formData = this.form.getRawValue();
    this.searchFired.emit({
      date_from: formData.date_from
        ? moment(formData.date_from).format('YYYY-MM-DD')
        : undefined,
      date_to: formData.date_to
        ? moment(formData.date_to).format('YYYY-MM-DD')
        : undefined,
      reservation_data: formData.reservation_data,
    });
  }
}
