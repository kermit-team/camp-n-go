import { inject } from '@angular/core';
import { AuthFacade } from '../services/auth.facade';
import {
  HttpErrorResponse,
  HttpEvent,
  HttpHandlerFn,
  HttpRequest,
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, switchMap } from 'rxjs/operators';

export function tokenInterceptor(
  req: HttpRequest<unknown>,
  next: HttpHandlerFn,
): Observable<HttpEvent<unknown>> {
  const authFacade = inject(AuthFacade);

  const isRefreshTokenRequest = req.url.includes('/refresh');

  const token = authFacade.getTokenFromStorage();
  if (token && !isRefreshTokenRequest) {
    req = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`,
      },
    });
  }

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      // Handle 401 errors
      if (error.status === 401 && !isRefreshTokenRequest) {
        console.error('Access token expired. Attempting to refresh...');

        return authFacade.refreshToken().pipe(
          switchMap((newToken: { access: string }) => {
            authFacade.saveAccessTokenToStorage(newToken.access);

            const refreshedRequest = req.clone({
              setHeaders: {
                Authorization: `Bearer ${newToken.access}`,
              },
            });

            return next(refreshedRequest);
          }),
          catchError((refreshError) => {
            console.error('Token refresh failed. Logging out.', refreshError);
            authFacade.logout();
            return throwError(() => refreshError);
          }),
        );
      }

      // If the error is not 401 or unhandled, propagate it
      return throwError(() => error);
    }),
  );
}
