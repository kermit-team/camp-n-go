import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  @JsonKey(name: 'results')
  final List<T> items;
  @JsonKey(name: 'page')
  final int currentPage;
  @JsonKey(name: 'count')
  final int totalItems;
  final Links? links;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalItems,
    this.links,
  });

  factory PaginatedResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

@JsonSerializable()
class Links {
  final String? next;
  final String? previous;

  Links({
    this.next,
    this.previous,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
