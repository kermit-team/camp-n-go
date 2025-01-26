import {
  Component,
  DestroyRef,
  inject,
  OnDestroy,
  OnInit,
  ViewChild,
} from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { DatepickerComponent } from '../../../shared/components/datepicker/datepicker.component';
import { PeoplePickerComponent } from '../../../shared/components/people-picker/people-picker/people-picker.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ParcelsFacade } from '../../services/parcels.facade';
import { ParcelSearchListComponent } from '../../components/parcel-search-list/parcel-search-list.component';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { ReserveCampingRequest } from '../../models/parcels.interface';

@Component({
  selector: 'app-parcel-search',
  standalone: true,
  templateUrl: './reservation-list.component.html',
  styleUrl: './reservation-list.component.scss',
  imports: [
    ReactiveFormsModule,
    DatepickerComponent,
    PeoplePickerComponent,
    ButtonComponent,
    ParcelSearchListComponent,
    AsyncPipe,
  ],
})
export class ReservationListComponent implements OnInit, OnDestroy {
  @ViewChild(PeoplePickerComponent) peoplePicker!: PeoplePickerComponent;
  private parcelsFacade = inject(ParcelsFacade);
  private destroyRef = inject(DestroyRef);

  dates = {
    dateFrom: this.parcelsFacade.getPassedData()?.startDate
      ? new Date(this.parcelsFacade.getPassedData()?.startDate)
      : new Date(),
    dateTo: this.parcelsFacade.getPassedData()?.endDate
      ? new Date(this.parcelsFacade.getPassedData()?.endDate)
      : new Date(),
  };

  people = {
    adultNumber: this.parcelsFacade.getPassedData()?.adultNumber ?? 1,
    childrenNumber: this.parcelsFacade.getPassedData()?.childrenNumber ?? 0,
  };

  parcels$ = this.parcelsFacade.selectParcelItems$();
  paginationMetadata$ = this.parcelsFacade.selectParcelPaginationMetadata$();

  reserve(reserve: ReserveCampingRequest) {
    this.parcelsFacade.reserveParcel({
      ...reserve,
      ...this.dates,
      ...this.people,
    });
  }

  search() {
    this.parcelsFacade.refreshParameters();
  }

  ngOnInit() {
    this.parcelsFacade.loadParcelsItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.parcelsFacade.setParcelPage(pageEvent.pageIndex + 1);
  }

  ngOnDestroy() {
    console.log('destroy');
  }
}
