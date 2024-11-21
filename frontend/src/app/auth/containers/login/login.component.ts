import { Component, inject } from '@angular/core';
import { RegisterFormComponent } from '../../components/register-form/register-form.component';
import { RouterLink } from '@angular/router';
import { RegisterRequest } from '../../models/register.interface';
import { AuthFacade } from '../../services/auth.facade';
import { LoginFormComponent } from '../../components/login-form/login-form.component';
import { LoginRequest } from '../../models/auth.interface';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [RegisterFormComponent, RouterLink, LoginFormComponent],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  private authFacade = inject(AuthFacade);

  login(formData: LoginRequest) {
    //this.authFacade.register(formData);
  }
}
