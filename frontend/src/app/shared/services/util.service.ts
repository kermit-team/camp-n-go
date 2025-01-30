import { inject, Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AlertComponent } from '../components/alert/alert.component';

@Injectable({
  providedIn: 'root',
})
export class UtilService {
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

  getPaymentStatus(status: number) {
    let statusText;
    switch (status) {
      case 0:
        statusText = 'Oczekujące na płatność';
        break;
      case 1:
        statusText = 'Odrzucona';
        break;
      case 2:
        statusText = 'Nieopłacona';
        break;
      case 3:
        statusText = 'Opłacona';
        break;
      case 4:
        statusText = 'Zwrócona';
        break;
    }
    return statusText;
  }
}
