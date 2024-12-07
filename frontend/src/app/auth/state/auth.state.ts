import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { AuthUser } from '../models/auth.interface';

@Injectable({
  providedIn: 'root',
})
export class AuthState {
  private token$ = new BehaviorSubject<string>(undefined);
  private refreshToken$ = new BehaviorSubject<string>(undefined);
  private tokenExpirationDate$ = new BehaviorSubject<string>(undefined);
  private authenticatedUser$ = new BehaviorSubject<AuthUser>(undefined);

  setToken(token: string) {
    this.token$.next(token);
  }

  setRefreshToken(refreshToken: string) {
    this.refreshToken$.next(refreshToken);
  }

  getToken(): string {
    return this.token$.getValue();
  }

  getRefreshToken(): string {
    return this.refreshToken$.getValue();
  }

  setAuthenticatedUser(user: AuthUser) {
    this.authenticatedUser$.next(user);
  }

  selectAuthenticatedUser$(): Observable<AuthUser> {
    return this.authenticatedUser$.asObservable();
  }
}
