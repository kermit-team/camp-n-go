// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      id: (json['id'] as num).toInt(),
      startDate: json['date_from'] as String,
      endDate: json['date_to'] as String,
      numberOfAdults: (json['number_of_adults'] as num).toInt(),
      numberOfChildren: (json['number_of_children'] as num).toInt(),
      comments: json['comments'] as String?,
      account: AccountDto.fromJson(json['user'] as Map<String, dynamic>),
      car: CarDto.fromJson(json['car'] as Map<String, dynamic>),
      parcel: ParcelDto.fromJson(json['camping_plot'] as Map<String, dynamic>),
      payment: PaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
      metadata: ReservationMetadataDto.fromJson(
          json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_from': instance.startDate,
      'date_to': instance.endDate,
      'number_of_adults': instance.numberOfAdults,
      'number_of_children': instance.numberOfChildren,
      'comments': instance.comments,
      'user': instance.account,
      'car': instance.car,
      'camping_plot': instance.parcel,
      'payment': instance.payment,
      'metadata': instance.metadata,
    };

ReservationMetadataDto _$ReservationMetadataDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationMetadataDto(
      isCancellable: json['is_cancellable'] as bool,
      isCarModifiable: json['is_car_modifiable'] as bool,
    );

Map<String, dynamic> _$ReservationMetadataDtoToJson(
        ReservationMetadataDto instance) =>
    <String, dynamic>{
      'is_cancellable': instance.isCancellable,
      'is_car_modifiable': instance.isCarModifiable,
    };
