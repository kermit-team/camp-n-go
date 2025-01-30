import { Component, EventEmitter, Output } from '@angular/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { ContactRequest } from '../../models/contact.interface';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { InputComponent } from '../../../shared/components/input/input.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { NgClass } from '@angular/common';

@Component({
  selector: 'app-contact-form',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatDatepickerModule,
    ButtonComponent,
    InputComponent,
    ErrorMessageComponent,
    NgClass,
  ],
  templateUrl: './contact-form.component.html',
  styleUrl: './contact-form.component.scss',
})
export class ContactFormComponent extends FormHelperComponent {
  @Output() formSubmit = new EventEmitter<ContactRequest>();

  constructor() {
    super();
    this.form = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      content: ['', [Validators.required]],
    });
  }

  send() {
    if (this.form.valid) {
      this.formSubmit.emit(this.form.value);
    } else {
      this.form.markAllAsTouched();
    }
  }
}
