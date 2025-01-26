// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParcelDto _$ParcelDtoFromJson(Map<String, dynamic> json) => ParcelDto(
      id: (json['id'] as num).toInt(),
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
    );

Map<String, dynamic> _$ParcelDtoToJson(ParcelDto instance) => <String, dynamic>{
      'id': instance.id,
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
    };
