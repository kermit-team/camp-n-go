import { Injectable } from '@angular/core';
import { SharedListState } from '../../shared/classes/list.state';
import { AdminUsersItem } from '../models/admin-users.interface';
import { BehaviorSubject } from 'rxjs';
import { LibSelectItem } from '../../shared/components/select/model/select.interface';
import { LibListRequestParams } from '../../shared/models/list.interface';

@Injectable({
  providedIn: 'root',
})
export class AdminUsersState extends SharedListState<AdminUsersItem> {
  private userGroups$ = new BehaviorSubject<LibSelectItem[]>(undefined);
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
}
