import { Component, Input } from '@angular/core';
import { AbstractControl } from '@angular/forms';
import { errorMessages } from '../../models/error-message.interface';

@Component({
  selector: 'lib-error-message',
  standalone: true,
  imports: [],
  templateUrl: './error-message.component.html',
  styleUrl: './error-message.component.scss',
})
export class ErrorMessageComponent {
  @Input() field: AbstractControl;

  get fieldTouched(): boolean {
    return this.field.touched;
  }

  protected readonly errorMessages = errorMessages;
}
