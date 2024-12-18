import { Component, EventEmitter, Output } from '@angular/core';
import {
  MatDialogActions,
  MatDialogContent,
  MatDialogRef,
  MatDialogTitle,
} from '@angular/material/dialog';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ReactiveFormsModule, Validators } from '@angular/forms';
import { InputComponent } from '../../../shared/components/input/input.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { passwordsMatchValidator } from '../../../shared/validators/same-password.validator';
import { PasswordEdit } from '../../models/profile.interface';

@Component({
  selector: 'app-profile-password-dialog',
  standalone: true,
  imports: [
    MatDialogActions,
    MatDialogContent,
    ButtonComponent,
    ReactiveFormsModule,
    InputComponent,
    ErrorMessageComponent,
    MatDialogTitle,
  ],
  templateUrl: './profile-password-dialog.component.html',
  styleUrl: './profile-password-dialog.component.scss',
})
export class ProfilePasswordDialogComponent extends FormHelperComponent {
  @Output() formSaved = new EventEmitter<PasswordEdit>();
  constructor(public dialogRef: MatDialogRef<ProfilePasswordDialogComponent>) {
    super();
    this.form = this.fb.group(
      {
        oldPassword: [undefined, Validators.required],
        password: [
          undefined,
          [
            Validators.required,
            Validators.minLength(9),
            Validators.pattern(/^(?=.*[A-Z])(?=.*[\W_]).+$/),
          ],
        ],
        confirmPassword: [undefined, Validators.required],
      },
      { validator: passwordsMatchValidator },
    );
  }

  onCancel() {
    this.dialogRef.close();
  }

  onEdit() {
    if (this.form.valid) {
      this.formSaved.emit({
        new_password: this.form.get('password').value,
        old_password: this.form.get('oldPassword').value,
      });
      this.dialogRef.close();
    } else {
      this.form.markAllAsTouched();
    }
  }
}
