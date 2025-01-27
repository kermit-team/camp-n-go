import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import {
  ControlValueAccessor,
  FormsModule,
  NG_VALUE_ACCESSOR,
  ReactiveFormsModule,
} from '@angular/forms';
import {
  MatDatepickerModule,
  MatDatepickerToggle,
} from '@angular/material/datepicker';
import {
  MatFormField,
  MatLabel,
  MatPrefix,
} from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';

@Component({
  selector: 'lib-datepicker',
  standalone: true,
  imports: [
    MatDatepickerToggle,
    ReactiveFormsModule,
    MatFormField,
    MatDatepickerModule,
    MatPrefix,
    MatInput,
    FormsModule,
    MatLabel,
  ],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: DatepickerComponent,
      multi: true,
    },
  ],
  templateUrl: './datepicker.component.html',
  styleUrls: ['./datepicker.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DatepickerComponent implements ControlValueAccessor {
  @Input() placeholder: string;

  value: Date | null = null;
  isDisabled = false;

  // Callback functions for ControlValueAccessor
  private onChange: (value: Date | null) => void = () => {};
  private onTouch: () => void = () => {};

  // Propagate changes from the control
  writeValue(value: Date | null): void {
    this.value = value;
  }

  registerOnChange(fn: (value: Date | null) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouch = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.isDisabled = isDisabled;
  }

  // When the user changes the date
  dateValueChanged(event: Date | null): void {
    this.value = event;
    this.onChange(this.value); // Notify Angular forms of the value change
    this.onTouch(); // Mark the field as touched
  }
}
