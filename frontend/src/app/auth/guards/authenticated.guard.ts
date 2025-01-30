import { inject, Injectable } from '@angular/core';
import { AuthFacade } from '../services/auth.facade';
import {
  ActivatedRouteSnapshot,
  CanActivateFn,
  Router,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { map, Observable } from 'rxjs';
import { AuthUser } from '../models/auth.interface';

@Injectable({
  providedIn: 'root',
})
export class AuthenticatedGuard {
  private readonly authFacade = inject(AuthFacade);
  private readonly router = inject(Router);

  canActivate(
    route: ActivatedRouteSnapshot,
  ): Observable<boolean | UrlTree> | UrlTree {
    const token = this.authFacade.getToken();

    if (token) {
      return this.authFacade.selectAuthenticated$().pipe(
        map((authUser: AuthUser) => {
          const canAccess = this.canAccess(authUser, route);
          return canAccess ? true : this.router.createUrlTree(['']);
        }),
      );
    } else {
      return this.router.parseUrl('');
    }
  }

  canAccess(authUser: AuthUser, route: ActivatedRouteSnapshot) {
    const mustBeAdmin: boolean = route.data?.['admin'];

    if (!authUser) {
      return false;
    }

    if (mustBeAdmin) {
      if (
        authUser.is_superuser ||
        authUser.groups.some((group) => group.name === 'Właściciel')
      ) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}

export const AuthGuard: CanActivateFn = (
  route: ActivatedRouteSnapshot,
  state: RouterStateSnapshot,
) => {
  return inject(AuthenticatedGuard).canActivate(route);
};
