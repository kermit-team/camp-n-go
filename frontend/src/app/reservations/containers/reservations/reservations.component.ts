import {
  Component,
  DestroyRef,
  inject,
  OnDestroy,
  OnInit,
} from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { AsyncPipe } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { Router } from '@angular/router';
import { ReservationsFacade } from '../../services/reservations.facade';
import { ReservationsListComponent } from '../../components/reservations-list/reservations-list.component';
import { MatDialog } from '@angular/material/dialog';
import { ConfirmationDialogComponent } from '../../../shared/components/confirmation-dialog/confirmation-dialog.component';

@Component({
  selector: 'app-parcel-search',
  standalone: true,
  templateUrl: './reservations.component.html',
  styleUrl: './reservations.component.scss',
  imports: [ReactiveFormsModule, AsyncPipe, ReservationsListComponent],
})
export class ReservationsComponent implements OnInit, OnDestroy {
  private reservationsFacade = inject(ReservationsFacade);
  private destroyRef = inject(DestroyRef);
  private dialog = inject(MatDialog);
  private router = inject(Router);

  reservations$ = this.reservationsFacade.selectReservationsItems$();
  paginationMetadata$ =
    this.reservationsFacade.selectReservationsPaginationMetadata$();

  ngOnInit() {
    this.reservationsFacade.loadReservationsItems(this.destroyRef);
  }

  onPaginationChanged(pageEvent: PageEvent) {
    this.reservationsFacade.setReservationsPage(pageEvent.pageIndex + 1);
  }

  cancel(id: number) {
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '350px',
    });

    dialogRef.componentInstance.accepted.subscribe(() => {
      this.reservationsFacade.cancelReservation(id);
    });
  }

  edit(id: number) {
    this.router.navigate([`/reservations/edit/${id}`]);
  }

  ngOnDestroy() {
    this.reservationsFacade.resetRezervationListParams();
  }
}
