import { Component, Input } from '@angular/core';
import { FormGroup, ReactiveFormsModule } from '@angular/forms';
import { InputComponent } from '../../../../shared/components/input/input.component';
import { FormHelperComponent } from '../../../../shared/classes/form-helper.component';
import { ErrorMessageComponent } from '../../../../shared/components/error-message/error-message.component';

@Component({
  selector: 'app-admin-users-general-form',
  standalone: true,
  imports: [ReactiveFormsModule, InputComponent, ErrorMessageComponent],
  templateUrl: './admin-users-general-form.component.html',
  styleUrl: './admin-users-general-form.component.scss',
})
export class AdminUsersGeneralFormComponent extends FormHelperComponent {
  @Input() set profileFormGroup(formGroup: FormGroup) {
    this.form = formGroup;
  }
}
