import { Component, inject } from '@angular/core';
import { AdminFacade } from '../../services/admin.facade';
import { AdminUsersAddEditRequest } from '../../models/admin-users.interface';
import { RouterLink } from '@angular/router';
import { AdminUsersAddContentComponent } from '../../components/admin-users-add-content/admin-users-add-content.component';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-admin-users-add',
  standalone: true,
  imports: [RouterLink, AdminUsersAddContentComponent, AsyncPipe],
  templateUrl: './admin-users-add.component.html',
  styleUrl: './admin-users-add.component.scss',
})
export class AdminUsersAddComponent {
  private adminFacade = inject(AdminFacade);

  userGroups$ = this.adminFacade.selectUserRoles$();

  userCreate(user: AdminUsersAddEditRequest) {
    this.adminFacade.createUser(user);
  }
}
