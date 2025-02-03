class GetParcelListParams {
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;

  GetParcelListParams({
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
  });
}
