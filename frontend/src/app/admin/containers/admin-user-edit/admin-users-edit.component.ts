import { Component, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { AdminFacade } from '../../services/admin.facade';
import { AdminUsersAddEditRequest } from '../../models/admin-users.interface';
import { AsyncPipe } from '@angular/common';
import { AdminUsersEditContentComponent } from '../../components/admin-users/admin-users-edit-content/admin-users-edit-content.component';

@Component({
  selector: 'app-admin-users',
  standalone: true,
  imports: [RouterLink, AsyncPipe, AdminUsersEditContentComponent],
  templateUrl: './admin-users-edit.component.html',
  styleUrl: './admin-users-edit.component.scss',
})
export class AdminUsersEditComponent {
  private adminFacade = inject(AdminFacade);
  private route = inject(ActivatedRoute);

  userGroups$ = this.adminFacade.selectUserRoles$();
  accountDetails$ = this.adminFacade.selectUserDetails$();

  userEdit(user: AdminUsersAddEditRequest) {
    const id = this.route.snapshot.params['id'];
    this.adminFacade.editUser(user, id);
  }
}
