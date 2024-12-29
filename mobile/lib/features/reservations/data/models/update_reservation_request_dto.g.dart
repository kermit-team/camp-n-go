// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reservation_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReservationRequestDto _$UpdateReservationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateReservationRequestDto(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      carRegistration: json['carRegistration'] as String?,
    );

Map<String, dynamic> _$UpdateReservationRequestDtoToJson(
        UpdateReservationRequestDto instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'carRegistration': instance.carRegistration,
    };
