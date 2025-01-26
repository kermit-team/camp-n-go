import { Component, EventEmitter, Input, Output } from '@angular/core';
import { LibPaginationMetadata } from '../../../shared/models/list.interface';
import {
  MatPaginator,
  MatPaginatorIntl,
  PageEvent,
} from '@angular/material/paginator';
import { AdminUsersItem } from '../../models/admin-users.interface';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
} from '@angular/material/table';
import { MyCustomPaginatorIntl } from '../../../shared/classes/mat-paginator-intl.component';

@Component({
  selector: 'app-admin-users-list',
  standalone: true,
  imports: [
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatCell,
    MatCellDef,
    MatHeaderCellDef,
    MatHeaderRow,
    MatRowDef,
    MatHeaderRowDef,
    MatRow,
    MatPaginator,
  ],
  providers: [[{ provide: MatPaginatorIntl, useClass: MyCustomPaginatorIntl }]],
  templateUrl: './admin-users-list.component.html',
  styleUrl: './admin-users-list.component.scss',
})
export class AdminUsersListComponent {
  @Input() items: AdminUsersItem[];
  @Input() set paginationMetadata(pagination: LibPaginationMetadata) {
    this.paginationData = pagination;
  }
  @Output() paginationChanged = new EventEmitter<PageEvent>();

  paginationData: LibPaginationMetadata;

  displayedColumns = ['imie', 'nazwisko', 'rola', 'email', 'actions'];

  handlePageEvent(e: PageEvent) {
    this.paginationChanged.emit(e);
  }

  getRoles(roles: Array<{ id: number; name: string }>) {
    return roles.map((r) => r.name).join(', ');
  }
}
