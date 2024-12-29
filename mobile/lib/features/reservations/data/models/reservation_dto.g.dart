// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      parcelNumber: (json['parcelNumber'] as num).toInt(),
      sector: json['sector'] as String,
      numberOfNights: (json['numberOfNights'] as num).toInt(),
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      idCard: json['idCard'] as String,
      cars: (json['cars'] as List<dynamic>)
          .map((e) => CarDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'parcelNumber': instance.parcelNumber,
      'sector': instance.sector,
      'numberOfNights': instance.numberOfNights,
      'adults': instance.adults,
      'children': instance.children,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'idCard': instance.idCard,
      'cars': instance.cars,
    };
