import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { InputComponent } from '../../../shared/components/input/input.component';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { AuthFacade } from '../../services/auth.facade';
import { passwordsMatchValidator } from '../../../shared/validators/same-password.validator';

@Component({
  selector: 'app-password-reset',
  standalone: true,
  imports: [
    RouterLink,
    ButtonComponent,
    InputComponent,
    ReactiveFormsModule,
    ErrorMessageComponent,
  ],
  templateUrl: './password-reset.component.html',
  styleUrl: './password-reset.component.scss',
})
export class PasswordResetComponent
  extends FormHelperComponent
  implements OnInit
{
  private route = inject(ActivatedRoute);
  private authFacade = inject(AuthFacade);

  uidb: string = this.route.snapshot.params['uidb64'];

  token: string = this.route.snapshot.params['token'];

  ngOnInit() {
    this.form = this.fb.group(
      {
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

  changePassword() {
    if (this.form.valid) {
      this.authFacade.resetPasswordChange(
        this.uidb,
        this.token,
        this.form.get('password').value,
      );
    } else {
      this.form.markAllAsTouched();
    }
  }
}
