import { inject, Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AlertComponent } from '../components/alert/alert.component';

@Injectable({
  providedIn: 'root',
})
export class AlertService {
  protected dialog = inject(MatDialog);

  showDialog(message: string, type: 'success' | 'warning' | 'error') {
    this.dialog.open(AlertComponent, {
      width: '500px',
      data: {
        content: message,
        type: type,
      },
    });
  }
}
