import {
  Component,
  DestroyRef,
  inject,
  OnInit,
  ViewChild,
} from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { DateRangePickerComponent } from '../../../shared/components/datepicker/date-range-picker/date-range-picker.component';
import { PeoplePickerComponent } from '../../../shared/components/people-picker/people-picker/people-picker.component';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { ParcelsFacade } from '../../services/parcels.facade';
import { ParcelSearchListComponent } from '../../components/parcel-search-list/parcel-search-list.component';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { Parcel } from '../../models/parcels.interface';
import { Router } from '@angular/router';
import moment from 'moment';

@Component({
  selector: 'app-parcel-search',
  standalone: true,
  templateUrl: './parcel-search.component.html',
  styleUrl: './parcel-search.component.scss',
  imports: [
    ReactiveFormsModule,
    DateRangePickerComponent,
    PeoplePickerComponent,
    ButtonComponent,
    ParcelSearchListComponent,
    AsyncPipe,
  ],
})
export class ParcelSearchComponent implements OnInit {
  @ViewChild(PeoplePickerComponent) peoplePicker!: PeoplePickerComponent;
  @ViewChild(DateRangePickerComponent) datepicker!: DateRangePickerComponent;
  private parcelsFacade = inject(ParcelsFacade);
  private destroyRef = inject(DestroyRef);
  private router = inject(Router);

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

  reserve(parcel: Parcel) {
    this.parcelsFacade.setParcelForReservation({
      ...parcel,
      date_from: this.datepicker.search.value.start.toISOString(),
      date_to: this.datepicker.search.value.end.toISOString(),
      number_of_adults: this.peoplePicker.adultNumber.getValue(),
      number_of_children: this.peoplePicker.childNumber.getValue(),
    });
    this.router.navigate([`/reservation-create`]);
  }

  search() {
    this.parcelsFacade.setParcelFilters({
      date_from: moment(this.datepicker.search.value.start).format(
        'YYYY-MM-DD',
      ),
      date_to: moment(this.datepicker.search.value.end).format('YYYY-MM-DD'),
      number_of_adults: this.peoplePicker.adultNumber.getValue(),
      number_of_children: this.peoplePicker.childNumber.getValue(),
    });
  }

  ngOnInit() {
    this.parcelsFacade.loadParcelsItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.parcelsFacade.setParcelPage(pageEvent.pageIndex + 1);
  }
}
