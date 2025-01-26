import { DestroyRef, inject, Injectable } from '@angular/core';
import { catchError, first, of, switchMap, tap } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { AdminUsersState } from '../state/admin-users.state';
import {
  AdminUsersFilters,
  AdminUsersItem,
} from '../models/admin-users.interface';
import { AdminApi } from './admin.api';
import { AlertService } from '../../shared/services/alert.service';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';

@Injectable({
  providedIn: 'root',
})
export class AdminFacade {
  private adminUsersState = inject(AdminUsersState);
  private adminApi = inject(AdminApi);
  private alertService = inject(AlertService);

  loadAdminUserItems(destroyRef: DestroyRef) {
    this.selectParcelListParams$()
      .pipe(
        switchMap((params: LibListRequestParams) =>
          this.adminApi.getAdminUsersList({ ...params }).pipe(
            catchError((error: Error) =>
              of({
                page: 0,
                count: 0,
                results: [],
              }),
            ),
          ),
        ),
        takeUntilDestroyed(destroyRef),
      )
      .subscribe({
        next: (response: LibListItem<AdminUsersItem>) => {
          this.adminUsersState.setItems(response.results);
          this.adminUsersState.setPaginationMetadata({
            currentPage: response.page,
            totalElements: response.count,
            currentLimit: 10,
          });
        },
        error: () => {
          this.adminUsersState.setItems([]);
        },
      });
  }

  selectParcelItems$() {
    return this.adminUsersState.selectItems$();
  }

  selectParcelListParams$() {
    return this.adminUsersState.selectListRequestParameters$();
  }

  selectParcelPaginationMetadata$() {
    return this.adminUsersState.selectPaginationMetadata$();
  }

  setParcelPage(newPage: number) {
    this.adminUsersState.setPage(newPage);
  }

  selectParcelFilters$() {
    return this.adminUsersState.selectFilters$();
  }

  setParcelFilters(filters: AdminUsersFilters) {
    this.adminUsersState.setListFilters(filters);
  }

  getUserRoles$() {
    return this.adminApi.getUserGroups().pipe(
      first(),
      catchError(() => {
        this.alertService.showDialog('Nie udało się pobrać grup', 'error');
        return of(undefined);
      }),
      tap((details: LibSelectItem[]) => {
        this.adminUsersState.setUserGroups(details);
      }),
    );
  }

  selectUserRoles$() {
    return this.adminUsersState.selectUserGroups$();
  }
}
