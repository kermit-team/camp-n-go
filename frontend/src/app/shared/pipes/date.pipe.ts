import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ standalone: true, name: 'dateNormalized' })
export class DateFormatPipe implements PipeTransform {
  transform(value: Date | string | number, ...args: any[]): string {
    if (!value) {
      return '';
    }

    const date = new Date(value);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // Miesiące są indeksowane od 0
    const year = date.getFullYear();

    return `${day}.${month}.${year}`;
  }
}
