import { Component, EventEmitter, inject, OnInit, Output } from '@angular/core';
import { ButtonComponent } from '../../../../shared/components/button/button.component';
import { InputComponent } from '../../../../shared/components/input/input.component';
import { AdminUsersFilters } from '../../../models/admin-users.interface';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule,
} from '@angular/forms';

@Component({
  selector: 'app-admin-reservations-filters',
  standalone: true,
  imports: [ButtonComponent, InputComponent, ReactiveFormsModule],
  templateUrl: './admin-reservations-filters.component.html',
  styleUrl: './admin-reservations-filters.component.scss',
})
export class AdminReservationsFiltersComponent implements OnInit {
  @Output() public searchFired = new EventEmitter<AdminUsersFilters>();

  private fb = inject(FormBuilder);

  form: FormGroup;

  constructor() {
    this.form = this.fb.group({
      group: undefined,
      personal_data: undefined,
    });
  }

  ngOnInit() {
    // this.form.patchValue({
    //   group: this.defaultOption.id,
    // });
  }

  search() {
    const data = {
      group:
        this.form.get('group').value !== -1
          ? this.form.get('group').value
          : undefined,
      personal_data: this.form.get('personal_data').value ?? undefined,
    };
    this.searchFired.emit(data);
  }

  get selectFormControl() {
    return this.form.get('group') as FormControl;
  }
}
