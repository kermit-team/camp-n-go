// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParcelDto _$ParcelDtoFromJson(Map<String, dynamic> json) => ParcelDto(
      parcelNumber: (json['parcelNumber'] as num).toInt(),
      maxPeople: (json['maxPeople'] as num).toInt(),
      description: json['description'] as String,
      parcelLength: (json['parcelLength'] as num).toDouble(),
      parcelWidth: (json['parcelWidth'] as num).toDouble(),
      hasElectricity: json['hasElectricity'] as bool,
      hasWater: json['hasWater'] as bool,
      hasGreyWaterDisposal: json['hasGreyWaterDisposal'] as bool,
      isShaded: json['isShaded'] as bool,
      pricePerParcel: (json['pricePerParcel'] as num).toDouble(),
      pricePerAdult: (json['pricePerAdult'] as num).toDouble(),
      pricePerChild: (json['pricePerChild'] as num).toDouble(),
      additionalNotes: json['additionalNotes'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ParcelDtoToJson(ParcelDto instance) => <String, dynamic>{
      'parcelNumber': instance.parcelNumber,
      'maxPeople': instance.maxPeople,
      'description': instance.description,
      'parcelLength': instance.parcelLength,
      'parcelWidth': instance.parcelWidth,
      'hasElectricity': instance.hasElectricity,
      'hasWater': instance.hasWater,
      'hasGreyWaterDisposal': instance.hasGreyWaterDisposal,
      'isShaded': instance.isShaded,
      'pricePerParcel': instance.pricePerParcel,
      'pricePerAdult': instance.pricePerAdult,
      'pricePerChild': instance.pricePerChild,
      'additionalNotes': instance.additionalNotes,
    };
