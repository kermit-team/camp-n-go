import { BehaviorSubject } from 'rxjs';
import {
  LibListRequestParams,
  LibPaginationMetadata,
} from '../models/list.interface';

export abstract class SharedListState<T> {
  protected items$ = new BehaviorSubject<Array<T>>(undefined);
  protected listRequestParameters$ = new BehaviorSubject<LibListRequestParams>({
    page: 1,
    page_size: 5,
  });
  protected paginationMetadata$ = new BehaviorSubject<LibPaginationMetadata>(
    undefined,
  );
  protected filters$ = new BehaviorSubject<Record<string, any>>(undefined);

  selectListRequestParameters$() {
    return this.listRequestParameters$.asObservable();
  }

  setItems(items: Array<T>) {
    this.items$.next([...items]);
  }

  selectItems$() {
    return this.items$.asObservable();
  }

  setPaginationMetadata(metadata: LibPaginationMetadata) {
    this.paginationMetadata$.next({ ...metadata });
  }

  selectPaginationMetadata$() {
    return this.paginationMetadata$.asObservable();
  }

  setPage(page: number) {
    this.listRequestParameters$.next({
      ...this.listRequestParameters$.getValue(),
      page,
    });
  }

  setListFilters(filters: Record<string, any>) {
    if (Object.keys(filters).length > 0) {
      this.setFilters(filters);
      this.listRequestParameters$.next({
        ...this.listRequestParameters$.getValue(),
        filters: filters,
      });
    } else {
      this.unsetListFilters();
    }
  }

  setFilters(filters: Record<string, any>) {
    this.filters$.next(filters);
  }

  unsetListFilters(): void {
    this.setFilters(undefined);
    const params = this.listRequestParameters$.getValue();
    delete params.filters;
    this.listRequestParameters$.next({ ...params });
  }

  selectFilters$() {
    return this.filters$.asObservable();
  }

  refreshListRequestParameters() {
    this.listRequestParameters$.next(this.listRequestParameters$.getValue());
  }

  resetListRequestParameters(pageSize = 10) {
    this.listRequestParameters$.next({
      page: 1,
      page_size: pageSize,
    });
  }
}
