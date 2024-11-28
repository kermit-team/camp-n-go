import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RegisterRequest } from '../models/register.interface';
import {BehaviorSubject} from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthState {
  private token$ = new BehaviorSubject<string>(undefined)
  private refreshToken$ = new BehaviorSubject<string>(undefined)
  private tokenExpirationDate$ = new BehaviorSubject<string>(undefined)

  setToken(token: string){
    this.token$.next(token)
  }

  setRefreshToken(refreshToken: string){
    this.refreshToken$.next(refreshToken)
  }

  getToken(): string {
    return this.token$.getValue()
  }

  getRefreshToken(): string {
    return this.refreshToken$.getValue()
  }


}
