import 'package:campngo/features/reservations/data/models/reservation_preview_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_reservations_response_dto.g.dart';

@JsonSerializable()
class MyReservationsResponseDto {
  final List<ReservationPreviewDto> reservations;
  final int currentPage;
  final int reservationsPerPage;
  final int totalReservations;

  MyReservationsResponseDto({
    required this.reservations,
    required this.currentPage,
    required this.reservationsPerPage,
    required this.totalReservations,
  });

  factory MyReservationsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MyReservationsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyReservationsResponseDtoToJson(this);
}
