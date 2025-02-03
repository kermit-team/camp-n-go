import { Component, inject, Input, OnDestroy } from '@angular/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { ReactiveFormsModule } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { PeoplePickerDialogComponent } from '../people-picker-dialog/people-picker-dialog.component';
import { BehaviorSubject, Subscription } from 'rxjs';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'lib-people-picker',
  standalone: true,
  imports: [ReactiveFormsModule, MatDatepickerModule, AsyncPipe],
  templateUrl: './people-picker.component.html',
  styleUrl: './people-picker.component.scss',
})
export class PeoplePickerComponent implements OnDestroy {
  @Input() set people({
    adultNumber,
    childrenNumber,
  }: {
    adultNumber?: number;
    childrenNumber?: number;
  }) {
    this.adultNumber.next(adultNumber);
    this.childNumber.next(childrenNumber);
  }
  private dialog = inject(MatDialog);
  private subscriptions = new Subscription();
  adultNumber = new BehaviorSubject<number>(1);
  childNumber = new BehaviorSubject<number>(0);

  openDialog() {
    const dialogRef = this.dialog.open(PeoplePickerDialogComponent, {
      width: '250px',
      data: {
        adultNumber: this.adultNumber.getValue(),
        childNumber: this.childNumber.getValue(),
      },
    });

    this.subscriptions.add(
      dialogRef.afterClosed().subscribe((result) => {
        this.adultNumber.next(result.adultNumber);
        this.childNumber.next(result.childNumber);
      }),
    );
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }
}
