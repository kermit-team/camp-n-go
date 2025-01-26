import { Component, DestroyRef, inject, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { AdminFacade } from '../../services/admin.facade';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { AdminUsersFilters } from '../../models/admin-users.interface';
import { AdminReservationsFiltersComponent } from '../../components/admin-reservations/admin-reservations-filters/admin-reservations-filters.component';
import { AdminReservationsListComponent } from '../../components/admin-reservations/admin-reservations-list/admin-reservations-list.component';

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
export class AdminReservationsComponent implements OnInit {
  private adminFacade = inject(AdminFacade);
  private destroyRef = inject(DestroyRef);
  private router = inject(Router);

  adminReservationItems$ = this.adminFacade.selectAdminReservationItems$();
  paginationMetadata$ =
    this.adminFacade.selectAdminReservationPaginationMetadata$();

  ngOnInit() {
    this.adminFacade.loadAdminReservationsItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.adminFacade.setAdminReservationPage(pageEvent.pageIndex + 1);
  }

  search(filters: AdminUsersFilters) {
    this.adminFacade.setAdminReservationFilters({ ...filters });
  }

  edit(id: string) {
    //todo dialog
  }
}
