// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_reservations_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyReservationsResponseDto _$MyReservationsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    MyReservationsResponseDto(
      reservations: (json['reservations'] as List<dynamic>)
          .map((e) => ReservationPreviewDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['currentPage'] as num).toInt(),
      reservationsPerPage: (json['reservationsPerPage'] as num).toInt(),
      totalReservations: (json['totalReservations'] as num).toInt(),
    );

Map<String, dynamic> _$MyReservationsResponseDtoToJson(
        MyReservationsResponseDto instance) =>
    <String, dynamic>{
      'reservations': instance.reservations,
      'currentPage': instance.currentPage,
      'reservationsPerPage': instance.reservationsPerPage,
      'totalReservations': instance.totalReservations,
    };
