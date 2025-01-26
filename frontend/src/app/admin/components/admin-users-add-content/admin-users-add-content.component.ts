import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { FormHelperComponent } from '../../../shared/classes/form-helper.component';
import { LibSelectItem } from '../../../shared/components/select/model/select.interface';
import {
  AdminUserDetails,
  AdminUsersAddEditRequest,
} from '../../models/admin-users.interface';
import { AdminUsersGeneralFormComponent } from '../admin-users-general-form/admin-users-general-form.component';
import { ErrorMessageComponent } from '../../../shared/components/error-message/error-message.component';
import { InputComponent } from '../../../shared/components/input/input.component';
import { SelectComponent } from '../../../shared/components/select/select.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';

@Component({
  selector: 'app-admin-users-add-content',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    AdminUsersGeneralFormComponent,
    ErrorMessageComponent,
    InputComponent,
    SelectComponent,
    ButtonComponent,
  ],
  templateUrl: './admin-users-add-content.component.html',
  styleUrl: './admin-users-add-content.component.scss',
})
export class AdminUsersAddContentComponent
  extends FormHelperComponent
  implements OnInit
{
  @Input() userGroups: LibSelectItem[];
  @Output() userCreated = new EventEmitter<AdminUsersAddEditRequest>();

  constructor() {
    super();
    this.form = this.fb.group({
      profile: this.fb.group({
        first_name: ['', Validators.required],
        last_name: ['', Validators.required],
        phone_number: undefined,
        id_card: undefined,
      }),

      email: ['', [Validators.required, Validators.email]],
      password: [
        '',
        [
          Validators.required,
          Validators.minLength(9),
          Validators.pattern(/^(?=.*[A-Z])(?=.*[\W_]).+$/),
        ],
      ],
      groups: undefined,
    });
  }

  ngOnInit() {
    this.form.patchValue({
      groups: this.userGroups[0].id,
    });
  }

  getProfileFormGroup() {
    return this.form.get('profile') as FormGroup;
  }

  createUser() {
    if (this.form.valid) {
      this.userCreated.emit({
        ...this.form.value,
        groups: [this.form.get('groups').value],
      });
    } else {
      this.form.markAllAsTouched();
    }
  }
}
