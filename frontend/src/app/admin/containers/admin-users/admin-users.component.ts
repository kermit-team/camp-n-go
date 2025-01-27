import { Component, DestroyRef, inject, OnInit } from '@angular/core';
import { AdminUsersFiltersComponent } from '../../components/admin-users/admin-users-filters/admin-users-filters.component';
import { AdminUsersListComponent } from '../../components/admin-users/admin-users-list/admin-users-list.component';
import { Router, RouterLink } from '@angular/router';
import { AdminFacade } from '../../services/admin.facade';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { AdminUsersFilters } from '../../models/admin-users.interface';

@Component({
  selector: 'app-admin-users',
  standalone: true,
  imports: [
    AdminUsersFiltersComponent,
    AdminUsersListComponent,
    RouterLink,
    AsyncPipe,
  ],
  templateUrl: './admin-users.component.html',
  styleUrl: './admin-users.component.scss',
})
export class AdminUsersComponent implements OnInit {
  private adminFacade = inject(AdminFacade);
  private destroyRef = inject(DestroyRef);
  private router = inject(Router);

  userGroups$ = this.adminFacade.selectUserRoles$();
  adminUsersItems$ = this.adminFacade.selectParcelItems$();
  paginationMetadata$ = this.adminFacade.selectParcelPaginationMetadata$();

  ngOnInit() {
    this.adminFacade.loadAdminUserItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.adminFacade.setParcelPage(pageEvent.pageIndex + 1);
  }

  search(filters: AdminUsersFilters) {
    this.adminFacade.setParcelFilters({ ...filters });
  }

  edit(id: string) {
    this.router.navigate(['admin/users/edit', id]);
  }
}
