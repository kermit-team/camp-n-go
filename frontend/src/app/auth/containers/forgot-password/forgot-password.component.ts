import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthFacade } from '../../services/auth.facade';
import { ForgotPasswordRequest } from '../../models/auth.interface';
import { ForgotPasswordFormComponent } from '../../components/forgot-password-form/forgot-password-form.component';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [RouterLink, ForgotPasswordFormComponent],
  templateUrl: './forgot-password.component.html',
  styleUrl: './forgot-password.component.scss',
})
export class ForgotPasswordComponent {
  private authFacade = inject(AuthFacade);

  forgotPassword(formData: ForgotPasswordRequest) {
    //this.authFacade.register(formData);
  }
}
