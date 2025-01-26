import { DestroyRef, inject, Injectable } from '@angular/core';
import { catchError, first, Observable, of, switchMap, tap } from 'rxjs';
import {
  LibListItem,
  LibListRequestParams,
} from '../../shared/models/list.interface';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { AdminUsersState } from '../state/admin-users.state';
import {
  AdminUserDetails,
  AdminUsersAddEditRequest,
  AdminUsersFilters,
  AdminUsersItem,
} from '../models/admin-users.interface';
import { AdminApi } from './admin.api';
import { AlertService } from '../../shared/services/alert.service';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class AdminFacade {
  private adminUsersState = inject(AdminUsersState);
  private adminApi = inject(AdminApi);
  private alertService = inject(AlertService);
  private router = inject(Router);

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

  getUserDetails(id: string) {
    return this.adminApi.getUserDetails(id).pipe(
      first(),
      catchError(() => {
        this.alertService.showDialog(
          'Nie udało się pobrać danych uzytkownika',
          'error',
        );
        return of(undefined);
      }),
      tap((details: AdminUserDetails) => {
        this.adminUsersState.setAccountDetails(details);
      }),
    );
  }

  selectUserRoles$() {
    return this.adminUsersState.selectUserGroups$();
  }

  selectUserDetails$() {
    return this.adminUsersState.selectAccountDetails$();
  }

  createUser(data: AdminUsersAddEditRequest) {
    this.adminApi
      .createUser(data)
      .pipe(first())
      .subscribe({
        next: (response: AdminUsersAddEditRequest) => {
          this.router.navigate(['/admin/users']).then(() => {
            this.alertService.showDialog('Dodano użytkownika', 'success');
          });
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało dodać się użytkownika',
            'error',
          );
        },
      });
  }

  editUser(data: AdminUsersAddEditRequest, id: string) {
    this.adminApi
      .editeUser(data, id)
      .pipe(first())
      .subscribe({
        next: (response: AdminUsersAddEditRequest) => {
          this.router.navigate(['/admin/users']).then(() => {
            this.alertService.showDialog(
              'Zmodyfikowano użytkownika',
              'success',
            );
          });
        },
        error: () => {
          this.alertService.showDialog(
            'Nie udało zmodyfikować się użytkownika',
            'error',
          );
        },
      });
  }
}
