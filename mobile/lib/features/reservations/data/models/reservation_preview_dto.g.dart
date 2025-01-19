// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewDto _$ReservationPreviewDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewDto(
      id: (json['id'] as num).toInt(),
      startDate: json['date_from'] as String,
      endDate: json['date_to'] as String,
      parcel: ParcelDto.fromJson(json['camping_plot'] as Map<String, dynamic>),
      payment: PaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
      metadata: ReservationPreviewMetadataDto.fromJson(
          json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationPreviewDtoToJson(
        ReservationPreviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_from': instance.startDate,
      'date_to': instance.endDate,
      'camping_plot': instance.parcel,
      'payment': instance.payment,
      'metadata': instance.metadata,
    };

ReservationPreviewMetadataDto _$ReservationPreviewMetadataDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewMetadataDto(
      isCancellable: json['is_cancellable'] as bool,
      isCarModifiable: json['is_car_modifiable'] as bool,
    );

Map<String, dynamic> _$ReservationPreviewMetadataDtoToJson(
        ReservationPreviewMetadataDto instance) =>
    <String, dynamic>{
      'is_cancellable': instance.isCancellable,
      'is_car_modifiable': instance.isCarModifiable,
    };
