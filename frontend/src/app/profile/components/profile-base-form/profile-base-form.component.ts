import { Component, EventEmitter, inject, Input, Output } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ProfileBaseDialogComponent } from '../profile-base-dialog/profile-base-dialog.component';
import { ProfilePasswordDialogComponent } from '../profile-password-dialog/profile-password-dialog.component';

@Component({
  selector: 'app-profile-base-form',
  standalone: true,
  imports: [],
  templateUrl: './profile-base-form.component.html',
  styleUrl: './profile-base-form.component.scss',
})
export class ProfileBaseFormComponent {
  @Input() data: string;
  @Input() title: string;
  @Input() isPassword = false;
  @Output() valueChanged = new EventEmitter<any>();

  private dialog = inject(MatDialog);

  opeEditForm() {
    if (this.isPassword) {
      const dialogRef = this.dialog.open(ProfilePasswordDialogComponent, {
        width: '350px',
      });

      dialogRef.componentInstance.formSaved.subscribe((result) => {
        this.valueChanged.emit(result);
      });
    } else {
      const dialogRef = this.dialog.open(ProfileBaseDialogComponent, {
        width: '350px',
        data: { title: this.title, formInfo: this.data },
      });

      dialogRef.componentInstance.formSaved.subscribe((result) => {
        this.valueChanged.emit(result.dataToEdit);
      });
    }
  }
}
