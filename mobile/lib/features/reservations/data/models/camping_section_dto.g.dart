// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camping_section_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampingSectionDto _$CampingSectionDtoFromJson(Map<String, dynamic> json) =>
    CampingSectionDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      basePrice: json['base_price'] as String,
      pricePerAdult: json['price_per_adult'] as String,
      pricePerChild: json['price_per_child'] as String,
    );

Map<String, dynamic> _$CampingSectionDtoToJson(CampingSectionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'base_price': instance.basePrice,
      'price_per_adult': instance.pricePerAdult,
      'price_per_child': instance.pricePerChild,
    };
