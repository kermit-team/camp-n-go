import { ChangeDetectionStrategy, Component, Inject } from '@angular/core';
import { NgClass } from '@angular/common';
import { MAT_DIALOG_DATA, MatDialogClose } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'lib-alert',
  standalone: true,
  imports: [MatDialogClose, NgClass, MatIconModule],
  templateUrl: './alert.component.html',
  styleUrl: './alert.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AlertComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: {
      content: string;
      type: 'success' | 'error' | 'warning';
    },
  ) {}
}
