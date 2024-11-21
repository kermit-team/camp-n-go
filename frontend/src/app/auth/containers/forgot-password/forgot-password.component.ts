import { Component, inject } from '@angular/core';
import { RegisterFormComponent } from '../../components/register-form/register-form.component';
import { RouterLink } from '@angular/router';
import { AuthFacade } from '../../services/auth.facade';
import { LoginFormComponent } from '../../components/login-form/login-form.component';
import { ForgotPasswordRequest } from '../../models/auth.interface';
import { ForgotPasswordFormComponent } from '../../components/forgot-password-form/forgot-password-form.component';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [
    RegisterFormComponent,
    RouterLink,
    LoginFormComponent,
    ForgotPasswordFormComponent,
  ],
  templateUrl: './forgot-password.component.html',
  styleUrl: './forgot-password.component.scss',
})
export class ForgotPasswordComponent {
  private authFacade = inject(AuthFacade);

  forgotPassword(formData: ForgotPasswordRequest) {
    //this.authFacade.register(formData);
  }
}
