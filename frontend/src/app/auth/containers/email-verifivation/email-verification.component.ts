import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { InputComponent } from '../../../shared/components/input/input.component';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { AuthFacade } from '../../services/auth.facade';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [
    RouterLink,
    ButtonComponent,
    InputComponent,
    ReactiveFormsModule,
    ErrorMessageComponent,
  ],
  templateUrl: './email-verification.component.html',
  styleUrl: './email-verification.component.scss',
})
export class EmailVerificationComponent
  extends FormHelperComponent
  implements OnInit
{
  private route = inject(ActivatedRoute);
  private authFacade = inject(AuthFacade);

  resolvedData: boolean =
    this.route.snapshot.data['emailVerification'].verified;

  ngOnInit() {
    this.form = this.fb.group({
      email: [undefined, Validators.required],
    });
  }

  sendEmail() {
    this.authFacade.resendEmail(this.form.get('email').value);
  }

  forgotPassword() {
    //this.authFacade.register(formData);
  }
}
