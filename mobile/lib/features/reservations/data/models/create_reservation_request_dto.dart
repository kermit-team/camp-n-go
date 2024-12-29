import 'package:json_annotation/json_annotation.dart';

part 'create_reservation_request_dto.g.dart';

@JsonSerializable()
class CreateReservationRequestDto {
  final int parcelNumber;
  final int adults;
  final int children;
  final DateTime startDate;
  final DateTime endDate;
  final String carRegistration;

  CreateReservationRequestDto({
    required this.parcelNumber,
    required this.adults,
    required this.children,
    required this.startDate,
    required this.endDate,
    required this.carRegistration,
  });

  factory CreateReservationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReservationRequestDtoToJson(this);
}
