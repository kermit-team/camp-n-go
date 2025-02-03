import { Component, forwardRef, Input } from '@angular/core';
import {
  ControlValueAccessor,
  FormsModule,
  NG_VALUE_ACCESSOR,
  ReactiveFormsModule,
} from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { LibSelectItem } from './model/select.interface';

@Component({
  selector: 'lib-select',
  standalone: true,
  imports: [
    FormsModule,
    MatFormFieldModule,
    MatSelectModule,
    MatInputModule,
    ReactiveFormsModule,
  ],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => SelectComponent),
      multi: true,
    },
  ],
  templateUrl: './select.component.html',
  styleUrl: './select.component.scss',
})
export class SelectComponent implements ControlValueAccessor {
  @Input() items: LibSelectItem[] = [];

  // Internal value for the control
  value: any;

  // Callbacks for form control changes
  private onChange = (value: any) => {};
  private onTouched = () => {};

  // Called by Angular to set the value programmatically
  writeValue(value: any): void {
    this.value = value;
  }

  // Called by Angular when the form control value changes
  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  // Called by Angular when the form control is touched
  registerOnTouched(fn: any): void {
    this.onTouched = fn;
  }

  // Optional: Called when the form control is disabled
  setDisabledState?(isDisabled: boolean): void {
    // You can implement this if needed
  }

  // Update value when user selects an option
  onValueChange(event: any): void {
    this.value = event.value;
    this.onChange(event.value); // Notify Angular of the value change
    this.onTouched(); // Mark control as touched
  }
}
