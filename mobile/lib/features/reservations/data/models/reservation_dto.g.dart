// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      id: (json['id'] as num).toInt(),
      startDate: DateTime.parse(json['date_from'] as String),
      endDate: DateTime.parse(json['date_to'] as String),
      numberOfAdults: (json['number_of_adults'] as num).toInt(),
      numberOfChildren: (json['number_of_children'] as num).toInt(),
      comments: json['comments'] as String?,
      account: AccountDto.fromJson(json['user'] as Map<String, dynamic>),
      car: CarDto.fromJson(json['car'] as Map<String, dynamic>),
      parcelDto:
          ParcelDto.fromJson(json['camping_plot'] as Map<String, dynamic>),
      payment: PaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
      isCancellable: json['is_cancellable'] as bool,
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_from': instance.startDate.toIso8601String(),
      'date_to': instance.endDate.toIso8601String(),
      'number_of_adults': instance.numberOfAdults,
      'number_of_children': instance.numberOfChildren,
      'comments': instance.comments,
      'user': instance.account,
      'car': instance.car,
      'camping_plot': instance.parcelDto,
      'payment': instance.payment,
      'is_cancellable': instance.isCancellable,
    };
