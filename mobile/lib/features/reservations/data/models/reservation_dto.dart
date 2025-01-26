import 'package:campngo/features/account_settings/data/models/account_dto.dart';
import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/data/models/payment_dto.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_dto.g.dart';

@JsonSerializable()
class ReservationDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'date_from')
  final String startDate;
  @JsonKey(name: 'date_to')
  final String endDate;
  @JsonKey(name: 'number_of_adults')
  final int numberOfAdults;
  @JsonKey(name: 'number_of_children')
  final int numberOfChildren;
  @JsonKey(name: 'comments')
  final String? comments;
  @JsonKey(name: 'user')
  final AccountDto account;
  @JsonKey(name: 'car')
  final CarDto car;
  @JsonKey(name: 'camping_plot')
  final ParcelDto parcel;
  @JsonKey(name: 'payment')
  final PaymentDto payment;
  @JsonKey(name: 'metadata')
  final ReservationMetadataDto metadata;

  ReservationDto({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numberOfAdults,
    required this.numberOfChildren,
    this.comments,
    required this.account,
    required this.car,
    required this.parcel,
    required this.payment,
    required this.metadata,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);

  factory ReservationDto.fromEntity(Reservation reservation) => ReservationDto(
        id: reservation.id,
        startDate: reservation.startDate.toIso8601String(),
        endDate: reservation.endDate.toIso8601String(),
        numberOfAdults: reservation.numberOfAdults,
        numberOfChildren: reservation.numberOfChildren,
        comments: reservation.comments,
        account: AccountDto.fromEntity(reservation.account, null),
        car: CarDto.fromEntity(reservation.car),
        parcel: ParcelDto.fromEntity(reservation.parcel),
        payment: PaymentDto.fromEntity(reservation.payment),
        metadata: ReservationMetadataDto.fromEntity(reservation.metadata),
      );

  Reservation toEntity() => Reservation(
        id: id,
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
        numberOfAdults: numberOfAdults,
        numberOfChildren: numberOfChildren,
        comments: comments,
        account: account.toEntity(),
        car: car.toEntity(),
        parcel: parcel.toEntity(),
        payment: payment.toEntity(),
        metadata: metadata.toEntity(),
      );
}

@JsonSerializable()
class ReservationMetadataDto {
  @JsonKey(name: 'is_cancellable')
  final bool isCancellable;
  @JsonKey(name: 'is_car_modifiable')
  final bool isCarModifiable;

  ReservationMetadataDto({
    required this.isCancellable,
    required this.isCarModifiable,
  });

  factory ReservationMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationMetadataDtoToJson(this);

  factory ReservationMetadataDto.fromEntity(ReservationMetadata entity) =>
      ReservationMetadataDto(
        isCancellable: entity.isCancellable,
        isCarModifiable: entity.isCarModifiable,
      );

  ReservationMetadata toEntity() => ReservationMetadata(
        isCancellable: isCancellable,
        isCarModifiable: isCarModifiable,
      );
}
