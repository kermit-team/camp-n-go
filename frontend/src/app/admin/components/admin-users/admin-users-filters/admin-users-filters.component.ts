import {
  Component,
  EventEmitter,
  inject,
  Input,
  OnInit,
  Output,
} from '@angular/core';
import { ButtonComponent } from '../../../../shared/components/button/button.component';
import { InputComponent } from '../../../../shared/components/input/input.component';
import { SelectComponent } from '../../../../shared/components/select/select.component';
import { AdminUsersFilters } from '../../../models/admin-users.interface';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule,
} from '@angular/forms';
import { LibSelectItem } from '../../../../shared/components/select/model/select.interface';

@Component({
  selector: 'app-admin-users-filters',
  standalone: true,
  imports: [
    ButtonComponent,
    InputComponent,
    SelectComponent,
    ReactiveFormsModule,
  ],
  templateUrl: './admin-users-filters.component.html',
  styleUrl: './admin-users-filters.component.scss',
})
export class AdminUsersFiltersComponent implements OnInit {
  @Input() set groups(items: LibSelectItem[]) {
    if (items) this.selectItems.push(...items);
  }
  @Output() public searchFired = new EventEmitter<AdminUsersFilters>();

  private fb = inject(FormBuilder);

  form: FormGroup;
  selectItems: LibSelectItem[] = [
    {
      id: -1,
      name: 'Wszyscy',
    },
  ];

  defaultOption = {
    id: -1,
    name: 'Wszyscy',
  };

  constructor() {
    this.form = this.fb.group({
      group: undefined,
      personal_data: undefined,
    });
  }

  ngOnInit() {
    this.form.patchValue({
      group: this.defaultOption.id,
    });
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
