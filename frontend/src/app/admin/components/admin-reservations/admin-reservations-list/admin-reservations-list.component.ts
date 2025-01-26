import { Component, EventEmitter, Input, Output } from '@angular/core';
import { LibPaginationMetadata } from '../../../../shared/models/list.interface';
import {
  MatPaginator,
  MatPaginatorIntl,
  PageEvent,
} from '@angular/material/paginator';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
} from '@angular/material/table';
import { MyCustomPaginatorIntl } from '../../../../shared/classes/mat-paginator-intl.component';
import { AdminReservationItem } from '../../../models/admin-reservations.interface';
import { DateFormatPipe } from '../../../../shared/pipes/date.pipe';

@Component({
  selector: 'app-admin-reservations-list',
  standalone: true,
  imports: [
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatCell,
    MatCellDef,
    MatHeaderCellDef,
    MatHeaderRow,
    MatRowDef,
    MatHeaderRowDef,
    MatRow,
    MatPaginator,
    DateFormatPipe,
  ],
  providers: [[{ provide: MatPaginatorIntl, useClass: MyCustomPaginatorIntl }]],
  templateUrl: './admin-reservations-list.component.html',
  styleUrl: './admin-reservations-list.component.scss',
})
export class AdminReservationsListComponent {
  @Input() items: AdminReservationItem[];
  @Input() set paginationMetadata(pagination: LibPaginationMetadata) {
    this.paginationData = pagination;
  }
  @Output() paginationChanged = new EventEmitter<PageEvent>();
  @Output() detailsFired = new EventEmitter<string>();

  paginationData: LibPaginationMetadata;

  displayedColumns = ['client', 'registration', 'period', 'status', 'actions'];

  handlePageEvent(e: PageEvent) {
    this.paginationChanged.emit(e);
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

  details(id: string) {
    this.detailsFired.emit(id);
  }
}
