import { Component, inject } from '@angular/core';
import { RegisterFormComponent } from '../../components/register-form/register-form.component';
import { RouterLink } from '@angular/router';
import { RegisterRequest } from '../../models/register.interface';
import { AuthFacade } from '../../services/auth.facade';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [RegisterFormComponent, RouterLink],
  templateUrl: './register.component.html',
  styleUrl: './register.component.scss',
})
export class RegisterComponent {
  private authFacade = inject(AuthFacade);

  register(formData: RegisterRequest) {
    this.authFacade.register(formData);
  }
}
