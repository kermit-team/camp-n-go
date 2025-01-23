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
      currentPage: (json['page'] as num).toInt(),
      totalItems: (json['count'] as num).toInt(),
      links: json['links'] == null
          ? null
          : Links.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'results': instance.items.map(toJsonT).toList(),
      'page': instance.currentPage,
      'count': instance.totalItems,
      'links': instance.links,
    };

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'next': instance.next,
      'previous': instance.previous,
    };
