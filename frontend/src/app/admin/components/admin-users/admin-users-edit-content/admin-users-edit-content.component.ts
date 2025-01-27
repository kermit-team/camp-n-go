import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { FormHelperComponent } from '../../../../shared/classes/form-helper.component';
import { LibSelectItem } from '../../../../shared/components/select/model/select.interface';
import {
  AdminUserDetails,
  AdminUsersAddEditRequest,
} from '../../../models/admin-users.interface';
import { AdminUsersGeneralFormComponent } from '../admin-users-general-form/admin-users-general-form.component';
import { SelectComponent } from '../../../../shared/components/select/select.component';
import { ButtonComponent } from '../../../../shared/components/button/button.component';
import { MatCheckbox } from '@angular/material/checkbox';

@Component({
  selector: 'app-admin-users-edit-content',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    AdminUsersGeneralFormComponent,
    SelectComponent,
    ButtonComponent,
    MatCheckbox,
  ],
  templateUrl: './admin-users-edit-content.component.html',
  styleUrl: './admin-users-edit-content.component.scss',
})
export class AdminUsersEditContentComponent
  extends FormHelperComponent
  implements OnInit
{
  @Input() userGroups: LibSelectItem[];
  @Input() accountDetails: AdminUserDetails;
  @Output() userEdited = new EventEmitter<AdminUsersAddEditRequest>();

  constructor() {
    super();
    this.form = this.fb.group({
      profile: this.fb.group({
        first_name: ['', Validators.required],
        last_name: ['', Validators.required],
        phone_number: undefined,
        id_card: undefined,
      }),
      groups: undefined,
      is_active: undefined,
    });
  }

  ngOnInit() {
    this.form.patchValue({
      ...this.accountDetails,
      groups: this.accountDetails.groups[0].id,
      is_active: this.accountDetails.is_active,
    });
  }

  getProfileFormGroup() {
    return this.form.get('profile') as FormGroup;
  }

  editUser() {
    if (this.form.valid) {
      const sanitizedFormValue: any = Object.fromEntries(
        Object.entries(this.form.value).filter(
          ([_, value]) => value !== null && value !== undefined,
        ),
      );

      this.userEdited.emit({
        ...sanitizedFormValue,
        groups: [this.form.get('groups').value],
      });
    } else {
      this.form.markAllAsTouched();
    }
  }
}
