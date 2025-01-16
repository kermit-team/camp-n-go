// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParcelListItemDto _$ParcelListItemDtoFromJson(Map<String, dynamic> json) =>
    ParcelListItemDto(
      parcelNumber: (json['id'] as num).toInt(),
      position: json['position'] as String,
      maxNumberOfPeople: (json['max_number_of_people'] as num).toInt(),
      width: json['width'] as String,
      length: json['length'] as String,
      waterConnection: json['water_connection'] as bool,
      electricityConnection: json['electricity_connection'] as bool,
      isShaded: json['is_shaded'] as bool,
      greyWaterDischarge: json['grey_water_discharge'] as bool,
      description: json['description'] as String,
      campingSection: CampingSectionDto.fromJson(
          json['camping_section'] as Map<String, dynamic>),
      price: json['price'] as String,
    );

Map<String, dynamic> _$ParcelListItemDtoToJson(ParcelListItemDto instance) =>
    <String, dynamic>{
      'id': instance.parcelNumber,
      'position': instance.position,
      'max_number_of_people': instance.maxNumberOfPeople,
      'width': instance.width,
      'length': instance.length,
      'water_connection': instance.waterConnection,
      'electricity_connection': instance.electricityConnection,
      'is_shaded': instance.isShaded,
      'grey_water_discharge': instance.greyWaterDischarge,
      'description': instance.description,
      'camping_section': instance.campingSection,
      'price': instance.price,
    };
