import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/data/models/payment_dto.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_preview_dto.g.dart';

@JsonSerializable()
class ReservationPreviewDto {
  @JsonKey(name: 'id')
  final int reservationId;
  @JsonKey(name: 'date_from')
  final DateTime startDate;
  @JsonKey(name: 'date_to')
  final DateTime endDate;
  @JsonKey(name: 'camping_plot')
  final ParcelDto parcel;
  @JsonKey(name: 'payment')
  final PaymentDto payment;
  @JsonKey(name: 'is_cancellable')
  final bool canCancel;

  ReservationPreviewDto({
    required this.reservationId,
    required this.startDate,
    required this.endDate,
    required this.parcel,
    required this.payment,
    required this.canCancel,
  });

  factory ReservationPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPreviewDtoToJson(this);

  factory ReservationPreviewDto.fromEntity(ReservationPreview entity) =>
      ReservationPreviewDto(
        reservationId: int.parse(entity.id),
        startDate: entity.startDate,
        endDate: entity.endDate,
        parcel: ParcelDto.fromEntity(entity.parcel),
        payment: PaymentDto.fromEntity(entity.payment),
        canCancel: entity.canCancel,
      );

  ReservationPreview toEntity() => ReservationPreview(
        id: reservationId.toString(),
        startDate: startDate,
        endDate: endDate,
        parcel: parcel.toEntity(),
        payment: payment.toEntity(),
        canCancel: canCancel,
      );
}
