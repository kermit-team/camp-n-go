import { inject } from '@angular/core';
import { ResolveFn } from '@angular/router';
import { EMPTY, mergeMap, of, take } from 'rxjs';
import { AdminFacade } from '../services/admin.facade';
import { AdminUserDetails } from '../models/admin-users.interface';

export const accountDetailsResolver: ResolveFn<AdminUserDetails> = (route) => {
  const adminFacade = inject(AdminFacade);
  const id = route.paramMap.get('id');

  return adminFacade.getUserDetails(id).pipe(
    take(1),
    mergeMap((data) => {
      if (data) {
        return of(data);
      } else {
        return EMPTY;
      }
    }),
  );
};
