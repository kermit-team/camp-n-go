// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_parcels_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableParcelsResponseDto _$AvailableParcelsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    AvailableParcelsResponseDto(
      parcels: (json['parcels'] as List<dynamic>)
          .map((e) => ParcelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['current_page'] as num).toInt(),
      itemsPerPage: (json['items_per_page'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
    );

Map<String, dynamic> _$AvailableParcelsResponseDtoToJson(
        AvailableParcelsResponseDto instance) =>
    <String, dynamic>{
      'parcels': instance.parcels,
      'current_page': instance.currentPage,
      'items_per_page': instance.itemsPerPage,
      'total_items': instance.totalItems,
    };
