class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
  });
}
