import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  @JsonKey(name: 'results')
  final List<T> items;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'items_per_page')
  final int itemsPerPage;
  @JsonKey(name: 'count')
  final int totalItems;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
  });

  factory PaginatedResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}
