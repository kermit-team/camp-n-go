import { inject } from '@angular/core';
import { ResolveFn } from '@angular/router';
import { EMPTY, mergeMap, of, take } from 'rxjs';
import { AdminFacade } from '../services/admin.facade';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';

export const userGroupsResolver: ResolveFn<LibSelectItem[]> = (route) => {
  const adminFacade = inject(AdminFacade);

  return adminFacade.getUserRoles$().pipe(
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
