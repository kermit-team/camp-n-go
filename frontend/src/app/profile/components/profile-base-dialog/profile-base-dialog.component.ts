import { Component, EventEmitter, Inject, Output } from '@angular/core';
import {
  MAT_DIALOG_DATA,
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

@Component({
  selector: 'app-profile-base-dialog',
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
  templateUrl: './profile-base-dialog.component.html',
  styleUrl: './profile-base-dialog.component.scss',
})
export class ProfileBaseDialogComponent extends FormHelperComponent {
  @Output() formSaved = new EventEmitter();
  constructor(
    public dialogRef: MatDialogRef<ProfileBaseDialogComponent>,
    @Inject(MAT_DIALOG_DATA)
    public data: { title?: string; formInfo?: string; titleCustom?: string },
  ) {
    super();
    this.form = this.fb.group({
      dataToEdit: [data.formInfo, Validators.required],
    });
  }

  onCancel() {
    this.dialogRef.close();
  }

  onEdit() {
    if (this.form.valid) {
      this.formSaved.emit(this.form.value);
      this.dialogRef.close();
    } else {
      this.form.markAllAsTouched();
    }
  }
}
