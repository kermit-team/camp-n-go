// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewDto _$ReservationPreviewDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewDto(
      reservationId: json['reservationId'] as String,
      parcelNumber: (json['parcelNumber'] as num).toInt(),
      reservationPrice: (json['reservationPrice'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      sector: json['sector'] as String,
      reservationStatus: json['reservationStatus'] as String,
      canCancel: json['canCancel'] as bool,
    );

Map<String, dynamic> _$ReservationPreviewDtoToJson(
        ReservationPreviewDto instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'parcelNumber': instance.parcelNumber,
      'reservationPrice': instance.reservationPrice,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'sector': instance.sector,
      'reservationStatus': instance.reservationStatus,
      'canCancel': instance.canCancel,
    };
