// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedResponse<T>(
      items: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
      currentPage: (json['current_page'] as num).toInt(),
      itemsPerPage: (json['items_per_page'] as num).toInt(),
      totalItems: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'results': instance.items.map(toJsonT).toList(),
      'current_page': instance.currentPage,
      'items_per_page': instance.itemsPerPage,
      'count': instance.totalItems,
    };
