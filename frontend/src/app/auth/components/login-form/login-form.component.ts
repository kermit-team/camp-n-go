import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { NgClass, NgOptimizedImage } from '@angular/common';
import { InputComponent } from '../../../shared/components/input/input.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { LoginRequest } from '../../models/auth.interface';

@Component({
  selector: 'app-login-form',
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
  templateUrl: './login-form.component.html',
  styleUrl: './login-form.component.scss',
})
export class LoginFormComponent extends FormHelperComponent implements OnInit {
  @Output() loginFired = new EventEmitter<LoginRequest>();

  ngOnInit(): void {
    this.form = this.fb.group({
      email: [undefined, [Validators.required, Validators.email]],
      password: [undefined, [Validators.required]],
    });
  }

  submitForm() {
    if (this.form.valid) {
      const data = this.form.value;
      this.loginFired.emit(data);
    } else {
      this.form.markAllAsTouched();
    }
  }
}
