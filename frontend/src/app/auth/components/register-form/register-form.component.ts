import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { NgClass, NgOptimizedImage } from '@angular/common';
import { InputComponent } from '../../../shared/components/input/input.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { passwordsMatchValidator } from '../../../shared/validators/same-password.validator';
import { RegisterRequest } from '../../models/register.interface';

@Component({
  selector: 'app-register-form',
  standalone: true,
  imports: [
    RouterLink,
    ReactiveFormsModule,
    NgClass,
    NgOptimizedImage,
    InputComponent,
    ButtonComponent,
    ErrorMessageComponent,
  ],
  templateUrl: './register-form.component.html',
  styleUrl: './register-form.component.scss',
})
export class RegisterFormComponent
  extends FormHelperComponent
  implements OnInit
{
  @Output() registerFired = new EventEmitter<RegisterRequest>();

  ngOnInit(): void {
    this.form = this.fb.group(
      {
        profile: this.fb.group({
          first_name: ['', Validators.required],
          last_name: ['', Validators.required],
        }),

        email: ['', [Validators.required, Validators.email]],
        password: [
          '',
          [
            Validators.required,
            Validators.minLength(9),
            Validators.pattern(/^(?=.*[A-Z])(?=.*[\W_]).+$/),
          ],
        ],
        confirmPassword: ['', Validators.required],
      },
      { validator: passwordsMatchValidator },
    );
  }

  submitForm() {
    if (this.form.valid) {
      const data = this.form.value;
      delete data.confirmPassword;
      this.registerFired.emit(data);
    } else {
      this.form.markAllAsTouched();
    }
  }
}
