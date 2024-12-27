import { Component, forwardRef, Input } from '@angular/core';
import {
  ControlValueAccessor,
  FormsModule,
  NG_VALUE_ACCESSOR,
  ReactiveFormsModule,
} from '@angular/forms';
import { NgClass } from '@angular/common';
import { errorMessages } from '../../models/error-message.interface';

@Component({
  selector: 'lib-input',
  standalone: true,
  imports: [ReactiveFormsModule, NgClass, FormsModule],
  templateUrl: './input.component.html',
  styleUrl: './input.component.scss',
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => InputComponent),
      multi: true,
    },
  ],
})
export class InputComponent implements ControlValueAccessor {
  @Input() id: number;
  @Input() fieldHasError: boolean;
  @Input() fieldRequired: boolean;
  @Input() placeholder: string;
  @Input() type: 'password' | 'text' = 'text';

  disabled: boolean;
  value: string;
  onChange: any;
  onTouched: () => void;
  controlFocused: boolean;

  get inputPlaceholder() {
    if (this.fieldRequired) {
      return `${this.placeholder}*`;
    }

    return this.placeholder;
  }

  registerOnChange(fn: any) {
    this.onChange = fn;
  }

  registerOnTouched(fn: any) {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean) {
    this.disabled = isDisabled;
  }

  writeValue(obj: any) {
    this.value = obj;
  }

  valueChanged(value: string): void {
    this.onChange(value);
    this.writeValue(value);
  }

  doFocus(): void {
    this.controlFocused = true;
  }

  onBlur(): void {
    this.onTouched();
    this.controlFocused = false;
  }

  protected readonly errorMessages = errorMessages;
}
