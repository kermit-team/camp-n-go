import {
  Component,
  DestroyRef,
  inject,
  OnDestroy,
  OnInit,
} from '@angular/core';
import { RouterLink } from '@angular/router';
import { AdminFacade } from '../../services/admin.facade';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { AdminReservationsFiltersComponent } from '../../components/admin-reservations/admin-reservations-filters/admin-reservations-filters.component';
import { AdminReservationsListComponent } from '../../components/admin-reservations/admin-reservations-list/admin-reservations-list.component';
import {
  AdminReservationFilters,
  AdminReservationItem,
} from '../../models/admin-reservations.interface';
import { MatDialog } from '@angular/material/dialog';
import { AdminReservationsDialogTableComponent } from '../../components/admin-reservations/admin-reservation-dialog-table/admin-reservations-dialog-table.component';

@Component({
  selector: 'app-admin-reservations',
  standalone: true,
  imports: [
    RouterLink,
    AsyncPipe,
    AdminReservationsFiltersComponent,
    AdminReservationsListComponent,
  ],
  templateUrl: './admin-reservations.component.html',
  styleUrl: './admin-reservations.component.scss',
})
export class AdminReservationsComponent implements OnInit, OnDestroy {
  private adminFacade = inject(AdminFacade);
  private destroyRef = inject(DestroyRef);
  private dialog = inject(MatDialog);

  adminReservationItems$ = this.adminFacade.selectAdminReservationItems$();
  paginationMetadata$ =
    this.adminFacade.selectAdminReservationPaginationMetadata$();

  ngOnInit() {
    this.adminFacade.loadAdminReservationsItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.adminFacade.setAdminReservationPage(pageEvent.pageIndex + 1);
  }

  search(filters: AdminReservationFilters) {
    this.adminFacade.setAdminReservationFilters({ ...filters });
  }

  showDetails(item: AdminReservationItem) {
    const dialogRef = this.dialog.open(AdminReservationsDialogTableComponent, {
      width: '500px',
      data: { reservationData: item },
    });
  }

  ngOnDestroy() {
    this.adminFacade.resetAdminReservationList();
  }
}
