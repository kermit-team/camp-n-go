// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reservation_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReservationRequestDto _$CreateReservationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateReservationRequestDto(
      startDate: json['date_from'] as String,
      endDate: json['date_to'] as String,
      numberOfAdults: (json['number_of_adults'] as num).toInt(),
      numberOfChildren: (json['number_of_children'] as num).toInt(),
      carId: (json['car'] as num).toInt(),
      parcelId: (json['camping_plot'] as num).toInt(),
      comments: json['comments'] as String?,
    );

Map<String, dynamic> _$CreateReservationRequestDtoToJson(
        CreateReservationRequestDto instance) =>
    <String, dynamic>{
      'date_from': instance.startDate,
      'date_to': instance.endDate,
      'number_of_adults': instance.numberOfAdults,
      'number_of_children': instance.numberOfChildren,
      'car': instance.carId,
      'camping_plot': instance.parcelId,
      'comments': instance.comments,
    };
