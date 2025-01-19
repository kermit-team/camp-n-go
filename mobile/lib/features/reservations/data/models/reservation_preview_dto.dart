import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/data/models/payment_dto.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_preview_dto.g.dart';

@JsonSerializable()
class ReservationPreviewDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'date_from')
  final String startDate;
  @JsonKey(name: 'date_to')
  final String endDate;
  @JsonKey(name: 'camping_plot')
  final ParcelDto parcel;
  @JsonKey(name: 'payment')
  final PaymentDto payment;
  @JsonKey(name: 'metadata')
  final ReservationPreviewMetadataDto metadata;

  ReservationPreviewDto({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.parcel,
    required this.payment,
    required this.metadata,
  });

  factory ReservationPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPreviewDtoToJson(this);

  factory ReservationPreviewDto.fromEntity(ReservationPreview entity) =>
      ReservationPreviewDto(
        id: int.parse(entity.id),
        startDate: entity.startDate.toIso8601String(),
        endDate: entity.endDate.toIso8601String(),
        parcel: ParcelDto.fromEntity(entity.parcel),
        payment: PaymentDto.fromEntity(entity.payment),
        metadata: ReservationPreviewMetadataDto(
          isCarModifiable: entity.canBeEdited,
          isCancellable: entity.canCancel,
        ),
      );

  ReservationPreview toEntity() => ReservationPreview(
        id: id.toString(),
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
        parcel: parcel.toEntity(),
        payment: payment.toEntity(),
        metadata: metadata.toEntity(),
      );
}

@JsonSerializable()
class ReservationPreviewMetadataDto {
  @JsonKey(name: 'is_cancellable')
  final bool isCancellable;
  @JsonKey(name: 'is_car_modifiable')
  final bool isCarModifiable;

  ReservationPreviewMetadataDto({
    required this.isCancellable,
    required this.isCarModifiable,
  });

  factory ReservationPreviewMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPreviewMetadataDtoToJson(this);

  factory ReservationPreviewMetadataDto.fromEntity(
          ReservationPreviewMetadata entity) =>
      ReservationPreviewMetadataDto(
        isCancellable: entity.isCancellable,
        isCarModifiable: entity.isCarModifiable,
      );
  ReservationPreviewMetadata toEntity() => ReservationPreviewMetadata(
        isCancellable: isCancellable,
        isCarModifiable: isCarModifiable,
      );
}
