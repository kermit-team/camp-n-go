import {ChangeDetectionStrategy, Component} from '@angular/core';
import {
  MatDatepickerModule,
  MatDatepickerToggle,
  MatDateRangeInput,
  MatDateRangePicker
} from '@angular/material/datepicker';
import {FormControl, FormGroup, ReactiveFormsModule} from '@angular/forms';
import {MatFormField, MatHint, MatLabel, MatPrefix, MatSuffix} from '@angular/material/form-field';
import {Router} from '@angular/router';
import {MAT_DATE_FORMATS, MatDateFormats, provideNativeDateAdapter} from '@angular/material/core';

export const CUSTOM_DATE_FORMATS: MatDateFormats = {
  parse: {
    dateInput: 'DD.MM.YYYY',
  },
  display: {
    dateInput: 'EEE. d MMM.', // Custom format (e.g., 'sob. 9 wrz.')
    monthYearLabel: 'MMM YYYY',
    dateA11yLabel: 'LL',
    monthYearA11yLabel: 'MMMM YYYY',
  },
};
@Component({
  selector: 'app-landing-page-form',
  standalone: true,
  imports: [
    MatDateRangeInput,
    MatDatepickerToggle,
    MatDateRangePicker,
    ReactiveFormsModule,
    MatSuffix,
    MatFormField,
    MatHint,
    MatLabel, MatDatepickerModule, MatPrefix
  ],
  templateUrl: './landing-page-form.component.html',
  styleUrl: './landing-page-form.component.scss',
  providers: [
    { provide: MAT_DATE_FORMATS, useValue: CUSTOM_DATE_FORMATS },
    provideNativeDateAdapter()],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LandingPageFormComponent {
  minDate: Date;
  tomorrow: Date;
  now = new Date();
  search = new FormGroup({
    start: new FormControl<Date>(new Date()),
    end: new FormControl<Date>(new Date(this.now.getFullYear(), this.now.getMonth(), this.now.getDate() + 1)),
    adults: new FormControl(1),
    children: new FormControl(0),
  });

  constructor(private _router: Router){
    const now = new Date();
    this.minDate = this.now;  // Set the minimum date to today
    this.tomorrow = new Date(this.now.getFullYear(), this.now.getMonth(), this.now.getDate() + 1);  // Tomorrow's date

  }
  //
  // readonly range = new FormGroup({
  //   start: new FormControl<Date | null>(null),
  //   end: new FormControl<Date | null>(null),
  // });

  onSubmit(){
    this._router.navigate([''], { state: { formData: this.search.value } });
  }
}
