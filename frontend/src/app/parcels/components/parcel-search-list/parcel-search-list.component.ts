import { Component, EventEmitter, Input, Output } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import {
  ParcelListItem,
  ReserveCampingRequest,
} from '../../models/parcels.interface';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import {
  MatPaginator,
  MatPaginatorIntl,
  PageEvent,
} from '@angular/material/paginator';
import { MyCustomPaginatorIntl } from '../../../shared/classes/mat-paginator-intl.component';
import { LibPaginationMetadata } from '../../../shared/models/list.interface';

@Component({
  selector: 'app-parcel-search-list',
  standalone: true,
  templateUrl: './parcel-search-list.component.html',
  styleUrl: './parcel-search-list.component.scss',
  imports: [ReactiveFormsModule, ButtonComponent, MatPaginator],
  providers: [{ provide: MatPaginatorIntl, useClass: MyCustomPaginatorIntl }],
})
export class ParcelSearchListComponent {
  @Input() items: ParcelListItem[];
  @Input() set paginationMetadata(pagination: LibPaginationMetadata) {
    this.paginationData = pagination;
  }
  @Output() paginationChanged = new EventEmitter<PageEvent>();
  @Output() reserveFired = new EventEmitter<ReserveCampingRequest>();

  paginationData: LibPaginationMetadata;

  handlePageEvent(e: PageEvent) {
    this.paginationChanged.emit(e);
  }

  reserveClicked(sectionName: string, position: string) {
    this.reserveFired.emit({ sectionName, position });
  }
}
