import { Component, EventEmitter, inject, Input, Output } from '@angular/core';
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
import { UtilService } from '../../../shared/services/util.service';

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

  private utilService = inject(UtilService);
  public getPaymentStatus = this.utilService.getPaymentStatus;

  paginationData: LibPaginationMetadata;

  handlePageEvent(e: PageEvent) {
    this.paginationChanged.emit(e);
  }

  onEditFired(id: number) {
    this.editFired.emit(id);
  }

  cancelReservation(id: number) {
    this.cancelFired.emit(id);
  }
}
