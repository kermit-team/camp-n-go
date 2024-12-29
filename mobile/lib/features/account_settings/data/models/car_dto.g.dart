// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarDto _$CarDtoFromJson(Map<String, dynamic> json) => CarDto(
      registrationPlate: json['registration_plate'] as String,
      assignedToReservation: json['assigned_to_reservation'] as bool? ?? false,
    );

Map<String, dynamic> _$CarDtoToJson(CarDto instance) => <String, dynamic>{
      'registration_plate': instance.registrationPlate,
      'assigned_to_reservation': instance.assignedToReservation,
    };
