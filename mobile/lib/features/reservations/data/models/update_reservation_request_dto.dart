import 'package:json_annotation/json_annotation.dart';

part 'update_reservation_request_dto.g.dart';

@JsonSerializable()
class UpdateReservationRequestDto {
  final String? carRegistration;

  UpdateReservationRequestDto({
    this.carRegistration,
  });

  factory UpdateReservationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateReservationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReservationRequestDtoToJson(this);
}
