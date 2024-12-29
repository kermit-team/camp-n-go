// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reservation_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReservationRequestDto _$CreateReservationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateReservationRequestDto(
      parcelNumber: (json['parcelNumber'] as num).toInt(),
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      carRegistration: json['carRegistration'] as String,
    );

Map<String, dynamic> _$CreateReservationRequestDtoToJson(
        CreateReservationRequestDto instance) =>
    <String, dynamic>{
      'parcelNumber': instance.parcelNumber,
      'adults': instance.adults,
      'children': instance.children,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'carRegistration': instance.carRegistration,
    };
