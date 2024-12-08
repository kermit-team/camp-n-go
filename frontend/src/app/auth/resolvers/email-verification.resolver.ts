import { inject } from '@angular/core';
import { AuthFacade } from '../services/auth.facade';
import { ResolveFn } from '@angular/router';
import { EMPTY, mergeMap, of, take } from 'rxjs';

export const emailVerificationResolver: ResolveFn<{ verified: boolean }> = (
  route,
) => {
  const authFacade = inject(AuthFacade);
  const uid64 = route.paramMap.get('uidb64');
  const token = route.paramMap.get('token');

  return authFacade.verifyEmail(uid64, token).pipe(
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
