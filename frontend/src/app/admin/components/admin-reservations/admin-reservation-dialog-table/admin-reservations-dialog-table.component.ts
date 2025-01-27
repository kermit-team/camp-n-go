import { Component, inject, Inject, OnInit } from '@angular/core';
import { MatPaginatorIntl } from '@angular/material/paginator';
import { MyCustomPaginatorIntl } from '../../../../shared/classes/mat-paginator-intl.component';
import { ButtonComponent } from '../../../../shared/components/button/button.component';
import { FormsModule } from '@angular/forms';
import {
  MAT_DIALOG_DATA,
  MatDialogActions,
  MatDialogContent,
  MatDialogRef,
  MatDialogTitle,
} from '@angular/material/dialog';
import { AdminReservationItem } from '../../../models/admin-reservations.interface';
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
import { UtilService } from '../../../../shared/services/util.service';

@Component({
  selector: 'app-admin-reservations-list',
  standalone: true,
  imports: [
    ButtonComponent,
    FormsModule,
    MatDialogActions,
    MatDialogContent,
    MatDialogTitle,
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatHeaderCellDef,
    MatCell,
    MatCellDef,
    MatHeaderRow,
    MatHeaderRowDef,
    MatRow,
    MatRowDef,
  ],
  providers: [[{ provide: MatPaginatorIntl, useClass: MyCustomPaginatorIntl }]],
  templateUrl: './admin-reservations-dialog-table.component.html',
  styleUrl: './admin-reservations-dialog-table.component.scss',
})
export class AdminReservationsDialogTableComponent implements OnInit {
  constructor(
    public dialogRef: MatDialogRef<AdminReservationsDialogTableComponent>,
    @Inject(MAT_DIALOG_DATA)
    public data: { reservationData: AdminReservationItem },
  ) {}

  displayedColumns: string[] = ['name', 'value'];
  dataSourceTransformed: { name: string; value: string }[];

  private utilService = inject(UtilService);
  public getPaymentStatus = this.utilService.getPaymentStatus;

  ngOnInit() {
    this.dataSourceTransformed = this.transformReservationToTable(
      this.data.reservationData,
    );
  }

  transformReservationToTable(
    reservation: AdminReservationItem,
  ): { name: string; value: string }[] {
    return [
      { name: 'Data Od', value: reservation.date_from },
      { name: 'Data Do', value: reservation.date_to },
      { name: 'Imię', value: reservation.user.profile.first_name },
      { name: 'Nazwisko', value: reservation.user.profile.last_name },
      {
        name: 'Tablica Rejestracyjna',
        value: reservation.car.registration_plate,
      },
      {
        name: 'Status Płatności',
        value: this.getPaymentStatus(reservation.payment.status),
      },
      { name: 'Cena Płatności', value: reservation.payment.price + 'zł' },
    ];
  }

  onCancel() {
    this.dialogRef.close();
  }
}
