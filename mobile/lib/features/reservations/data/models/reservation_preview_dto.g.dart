// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewDto _$ReservationPreviewDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewDto(
      reservationId: (json['id'] as num).toInt(),
      startDate: DateTime.parse(json['date_from'] as String),
      endDate: DateTime.parse(json['date_to'] as String),
      parcel: ParcelDto.fromJson(json['camping_plot'] as Map<String, dynamic>),
      payment: PaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
      canCancel: json['is_cancellable'] as bool,
    );

Map<String, dynamic> _$ReservationPreviewDtoToJson(
        ReservationPreviewDto instance) =>
    <String, dynamic>{
      'id': instance.reservationId,
      'date_from': instance.startDate.toIso8601String(),
      'date_to': instance.endDate.toIso8601String(),
      'camping_plot': instance.parcel,
      'payment': instance.payment,
      'is_cancellable': instance.canCancel,
    };
