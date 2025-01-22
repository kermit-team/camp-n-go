import { Component, EventEmitter, Input, Output } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import {
  MatPaginator,
  MatPaginatorIntl,
  PageEvent,
} from '@angular/material/paginator';
import { MyCustomPaginatorIntl } from '../../../shared/classes/mat-paginator-intl.component';
import { LibPaginationMetadata } from '../../../shared/models/list.interface';
import { ReservationListItem } from '../../models/reservation.interface';
import { DateFormatPipe } from '../../../shared/pipes/date.pipe';

@Component({
  selector: 'app-reservations-list',
  standalone: true,
  templateUrl: './reservations-list.component.html',
  styleUrl: './reservations-list.component.scss',
  imports: [ReactiveFormsModule, MatPaginator, DateFormatPipe],
  providers: [{ provide: MatPaginatorIntl, useClass: MyCustomPaginatorIntl }],
})
export class ReservationsListComponent {
  @Input() items: ReservationListItem[];
  @Input() set paginationMetadata(pagination: LibPaginationMetadata) {
    this.paginationData = pagination;
  }
  @Output() paginationChanged = new EventEmitter<PageEvent>();
  @Output() editFired = new EventEmitter<number>();
  @Output() cancelFired = new EventEmitter<number>();

  paginationData: LibPaginationMetadata;

  handlePageEvent(e: PageEvent) {
    this.paginationChanged.emit(e);
  }

  onEditFired(id: number) {
    this.editFired.emit(id);
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

  cancelReservation(id: number) {
    this.cancelFired.emit(id);
  }
}
