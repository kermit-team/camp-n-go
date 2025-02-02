import {
  ChangeDetectionStrategy,
  Component,
  EventEmitter,
  Output,
  ViewChild,
} from '@angular/core';
import {
  MatDatepickerModule,
  MatDatepickerToggle,
  MatDateRangeInput,
  MatDateRangePicker,
} from '@angular/material/datepicker';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { MatFormField, MatPrefix } from '@angular/material/form-field';
import { Router } from '@angular/router';
import { PeoplePickerComponent } from '../../../shared/components/people-picker/people-picker/people-picker.component';
import { PassedData } from '../../../parcels/models/parcels.interface';
import moment from 'moment/moment';

@Component({
  selector: 'app-landing-page-form',
  standalone: true,
  imports: [
    MatDateRangeInput,
    MatDatepickerToggle,
    MatDateRangePicker,
    ReactiveFormsModule,
    MatFormField,
    MatDatepickerModule,
    MatPrefix,
    PeoplePickerComponent,
  ],
  templateUrl: './landing-page-form.component.html',
  styleUrl: './landing-page-form.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LandingPageFormComponent {
  @Output() searchFired = new EventEmitter<PassedData>();
  @ViewChild(PeoplePickerComponent) peoplePicker!: PeoplePickerComponent;
  minDate: Date;
  tomorrow: Date;
  now = new Date();
  search = new FormGroup({
    start: new FormControl<Date>(new Date()),
    end: new FormControl<Date>(
      new Date(
        this.now.getFullYear(),
        this.now.getMonth(),
        this.now.getDate() + 1,
      ),
    ),
  });

  constructor(private router: Router) {
    this.minDate = this.now;
    this.tomorrow = new Date(
      this.now.getFullYear(),
      this.now.getMonth(),
      this.now.getDate() + 1,
    );

    this.search.get('start').disable();
    this.search.get('end').disable();
  }

  searchParcels() {
    this.searchFired.emit({
      startDate: moment(this.search.value.start).format('YYYY-MM-DD'),
      endDate: moment(this.search.value.end).format('YYYY-MM-DD'),
      adultNumber: this.peoplePicker.adultNumber.getValue(),
      childrenNumber: this.peoplePicker.childNumber.getValue(),
    });
  }
}
