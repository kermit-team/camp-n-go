import { inject, Injectable } from '@angular/core';
import { AuthFacade } from '../services/auth.facade';
import {
  ActivatedRouteSnapshot,
  CanActivateFn,
  RouterStateSnapshot,
} from '@angular/router';
import { map, Observable, of } from 'rxjs';
import { AuthUser } from '../models/auth.interface';

@Injectable({
  providedIn: 'root',
})
export class AuthenticatedGuard {
  private readonly authFacade: AuthFacade;

  canActivate(route: ActivatedRouteSnapshot): Observable<boolean> {
    const token = this.authFacade.getToken();

    if (token) {
      return this.authFacade
        .selectAuthenticated$()
        .pipe(map((authUser: AuthUser) => this.canAccess(authUser, route)));
    } else {
      return of(false);
    }
  }

  canAccess(authUser: AuthUser, route: ActivatedRouteSnapshot) {
    const isAdmin: boolean = route.data?.['admin'];

    if (!authUser) {
      return false;
    }

    return true; // todo if property isAdmin is implemented

    // if (isAdmin && isAdmin === authUser.isAdmin) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}

export const AuthGuard: CanActivateFn = (
  route: ActivatedRouteSnapshot,
  state: RouterStateSnapshot,
) => {
  return inject(AuthenticatedGuard).canActivate(route);
};
