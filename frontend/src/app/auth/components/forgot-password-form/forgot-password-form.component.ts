import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { InputComponent } from '../../../shared/components/input/input.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';

@Component({
  selector: 'app-forgot-password-form',
  standalone: true,
  imports: [
    RouterLink,
    ReactiveFormsModule,
    InputComponent,
    ButtonComponent,
    ErrorMessageComponent,
  ],
  templateUrl: './forgot-password-form.component.html',
  styleUrl: './forgot-password-form.component.scss',
})
export class ForgotPasswordFormComponent
  extends FormHelperComponent
  implements OnInit
{
  @Output() forgotFired = new EventEmitter<string>();

  ngOnInit(): void {
    this.form = this.fb.group({
      email: [undefined, [Validators.required, Validators.email]],
    });
  }

  submitForm() {
    if (this.form.valid) {
      const data = this.form.value;
      this.forgotFired.emit(data);
    } else {
      this.form.markAllAsTouched();
    }
  }
}
