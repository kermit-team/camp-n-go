// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      id: json['id'] as String,
      parcel: ParcelDto.fromJson(json['parcel'] as Map<String, dynamic>),
      account: AccountDto.fromJson(json['account'] as Map<String, dynamic>),
      numberOfNights: (json['numberOfNights'] as num).toInt(),
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      car: CarDto.fromJson(json['car'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parcel': instance.parcel,
      'account': instance.account,
      'numberOfNights': instance.numberOfNights,
      'adults': instance.adults,
      'children': instance.children,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'car': instance.car,
    };
