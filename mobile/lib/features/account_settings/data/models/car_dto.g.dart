// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarDto _$CarDtoFromJson(Map<String, dynamic> json) => CarDto(
      id: (json['id'] as num).toInt(),
      registrationPlate: json['registration_plate'] as String,
    );

Map<String, dynamic> _$CarDtoToJson(CarDto instance) => <String, dynamic>{
      'id': instance.id,
      'registration_plate': instance.registrationPlate,
    };
