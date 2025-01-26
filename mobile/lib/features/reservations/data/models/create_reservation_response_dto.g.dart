// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reservation_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReservationResponseDto _$CreateReservationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    CreateReservationResponseDto(
      id: (json['id'] as num).toInt(),
      startDate: json['date_from'] as String,
      endDate: json['date_to'] as String,
      numberOfAdults: (json['number_of_adults'] as num).toInt(),
      numberOfChildren: (json['number_of_children'] as num).toInt(),
      carId: (json['car'] as num).toInt(),
      parcelId: (json['camping_plot'] as num).toInt(),
      comments: json['comments'] as String?,
      stripeUrl: json['checkout_url'] as String,
    );

Map<String, dynamic> _$CreateReservationResponseDtoToJson(
        CreateReservationResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_from': instance.startDate,
      'date_to': instance.endDate,
      'number_of_adults': instance.numberOfAdults,
      'number_of_children': instance.numberOfChildren,
      'car': instance.carId,
      'camping_plot': instance.parcelId,
      'comments': instance.comments,
      'checkout_url': instance.stripeUrl,
    };
