import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_preview_dto.g.dart';

@JsonSerializable()
class ReservationPreviewDto {
  final String reservationId;
  final int parcelNumber;
  final double reservationPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String sector;
  final String reservationStatus;
  final bool canCancel;

  ReservationPreviewDto({
    required this.reservationId,
    required this.parcelNumber,
    required this.reservationPrice,
    required this.startDate,
    required this.endDate,
    required this.sector,
    required this.reservationStatus,
    required this.canCancel,
  });

  factory ReservationPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPreviewDtoToJson(this);

  factory ReservationPreviewDto.fromEntity(ReservationPreview entity) =>
      ReservationPreviewDto(
        reservationId: entity.reservationId,
        parcelNumber: entity.parcelNumber,
        reservationPrice: entity.reservationPrice,
        startDate: entity.startDate,
        endDate: entity.endDate,
        sector: entity.sector,
        reservationStatus: entity.reservationStatus,
        canCancel: entity.canCancel,
      );

  ReservationPreview toEntity() => ReservationPreview(
        reservationId: reservationId,
        parcelNumber: parcelNumber,
        reservationPrice: reservationPrice,
        startDate: startDate,
        endDate: endDate,
        sector: sector,
        reservationStatus: reservationStatus,
        canCancel: canCancel,
      );
}
