import { Injectable } from '@angular/core';
import { SharedListState } from '../../shared/classes/list.state';
import {
  AdminUserDetails,
  AdminUsersItem,
} from '../models/admin-users.interface';
import { BehaviorSubject } from 'rxjs';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';
import { LibListRequestParams } from '../../shared/models/list.interface';

@Injectable({
  providedIn: 'root',
})
export class AdminUsersState extends SharedListState<AdminUsersItem> {
  private userGroups$ = new BehaviorSubject<LibSelectItem[]>(undefined);
  private accountDetails$ = new BehaviorSubject<AdminUserDetails>(undefined);
  override listRequestParameters$ = new BehaviorSubject<LibListRequestParams>({
    page: 1,
    page_size: 10,
  });

  setUserGroups(userDetails: LibSelectItem[]) {
    this.userGroups$.next(userDetails);
  }

  selectUserGroups$() {
    return this.userGroups$.asObservable();
  }

  setAccountDetails(accountDetails: AdminUserDetails) {
    this.accountDetails$.next(accountDetails);
  }

  selectAccountDetails$() {
    return this.accountDetails$.asObservable();
  }
}
