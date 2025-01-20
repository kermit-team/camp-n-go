import { Subject } from 'rxjs';
import { Injectable } from '@angular/core';
import { MatPaginatorIntl } from '@angular/material/paginator';

@Injectable()
export class MyCustomPaginatorIntl implements MatPaginatorIntl {
  changes = new Subject<void>();

  firstPageLabel = `Pierwsza strona`;
  itemsPerPageLabel = `Pozycje na stronę:`;
  lastPageLabel = `Ostatnia strona`;
  nextPageLabel = 'Następna strona';
  previousPageLabel = 'Poprzednia strona';

  getRangeLabel(page: number, pageSize: number, length: number): string {
    if (length === 0) {
      return `Strona 1 z 1`;
    }
    const amountPages = Math.ceil(length / pageSize);
    return `Strona ${page + 1} z ${amountPages}`;
  }
}
