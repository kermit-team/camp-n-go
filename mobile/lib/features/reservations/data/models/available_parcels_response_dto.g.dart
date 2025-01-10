// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_parcels_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableParcelsResponseDto _$AvailableParcelsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    AvailableParcelsResponseDto(
      parcels: (json['results'] as List<dynamic>)
          .map((e) => ParcelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['page'] as num).toInt(),
      totalItems: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$AvailableParcelsResponseDtoToJson(
        AvailableParcelsResponseDto instance) =>
    <String, dynamic>{
      'results': instance.parcels,
      'page': instance.currentPage,
      'count': instance.totalItems,
    };
