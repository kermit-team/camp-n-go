export interface LibListItem<TResult> {
  page: number;
  count: number;
  results: Array<TResult>;
}

export interface LibListRequestParams {
  page: number;
  page_size: number;
  filters?: any;
}

export interface LibPaginationMetadata {
  currentPage: number;
  currentPageIndex?: number;
  currentLimit: number;
  totalElements: number;
}
