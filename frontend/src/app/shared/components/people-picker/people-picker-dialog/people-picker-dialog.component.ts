import { Component, Inject } from '@angular/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ButtonComponent } from '../../button/button.component';

@Component({
  selector: 'app-people-picker-dialog',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatDatepickerModule,
    ButtonComponent,
    FormsModule,
  ],
  templateUrl: './people-picker-dialog.component.html',
  styleUrl: './people-picker-dialog.component.scss',
})
export class PeoplePickerDialogComponent {
  constructor(
    public dialogRef: MatDialogRef<PeoplePickerDialogComponent>,
    @Inject(MAT_DIALOG_DATA)
    public data: { adultNumber: number; childNumber: number },
  ) {}

  closeDialog() {
    this.dialogRef.close(this.data);
  }
}
