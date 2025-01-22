import { Component, EventEmitter, Output } from '@angular/core';
import {
  MatDialogActions,
  MatDialogRef,
  MatDialogTitle,
} from '@angular/material/dialog';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-profile-base-dialog',
  standalone: true,
  imports: [
    MatDialogActions,
    ButtonComponent,
    ReactiveFormsModule,
    MatDialogTitle,
  ],
  templateUrl: './confirmation-dialog.component.html',
  styleUrl: './confirmation-dialog.component.scss',
})
export class ConfirmationDialogComponent {
  @Output() accepted = new EventEmitter<void>();

  constructor(public dialogRef: MatDialogRef<ConfirmationDialogComponent>) {}

  cancel() {
    this.dialogRef.close();
  }

  accept() {
    this.accepted.emit();
    this.dialogRef.close();
  }
}
