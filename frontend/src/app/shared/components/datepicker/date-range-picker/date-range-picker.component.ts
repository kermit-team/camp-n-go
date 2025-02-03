import { Component, Input } from '@angular/core';
import {
  MatDatepickerModule,
  MatDatepickerToggle,
  MatDateRangeInput,
  MatDateRangePicker,
} from '@angular/material/datepicker';
import { MatFormField, MatPrefix } from '@angular/material/form-field';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'lib-date-range-picker',
  standalone: true,
  imports: [
    MatDateRangeInput,
    MatDatepickerToggle,
    MatDateRangePicker,
    ReactiveFormsModule,
    MatFormField,
    MatDatepickerModule,
    MatPrefix,
  ],
  templateUrl: './date-range-picker.component.html',
  styleUrl: './date-range-picker.component.scss',
})
export class DateRangePickerComponent {
  private readonly now: Date = new Date();
  private readonly tomorrow: Date = new Date(
    this.now.getFullYear(),
    this.now.getMonth(),
    this.now.getDate() + 1,
  );

  @Input()
  set dates({ dateFrom, dateTo }: { dateFrom?: Date; dateTo?: Date }) {
    this.dateFrom = dateFrom || this.now;
    this.dateTo = dateTo || this.tomorrow;
    this.patchForm({ dateFrom, dateTo });
  }

  dateFrom: Date = this.now;
  dateTo: Date = this.tomorrow;
  minDate: Date = this.now;

  search: FormGroup = new FormGroup({
    start: new FormControl<Date>(this.dateFrom),
    end: new FormControl<Date>(this.tomorrow),
  });

  constructor() {
    this.search.get('start').disable();
    this.search.get('end').disable();
  }

  private patchForm({ dateFrom, dateTo }: { dateFrom?: Date; dateTo?: Date }) {
    this.search.patchValue({
      start: dateFrom,
      end: dateTo,
    });
  }
}
