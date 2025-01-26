// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_parcels_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableParcelsResponseDto _$AvailableParcelsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    AvailableParcelsResponseDto(
      totalItems: (json['count'] as num).toInt(),
      links: LinksDto.fromJson(json['links'] as Map<String, dynamic>),
      currentPage: (json['page'] as num).toInt(),
      parcels: (json['results'] as List<dynamic>)
          .map((e) => ParcelListItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvailableParcelsResponseDtoToJson(
        AvailableParcelsResponseDto instance) =>
    <String, dynamic>{
      'count': instance.totalItems,
      'links': instance.links,
      'page': instance.currentPage,
      'results': instance.parcels,
    };

LinksDto _$LinksDtoFromJson(Map<String, dynamic> json) => LinksDto(
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );

Map<String, dynamic> _$LinksDtoToJson(LinksDto instance) => <String, dynamic>{
      'next': instance.next,
      'previous': instance.previous,
    };
