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
  final DateTime startDate;
  @JsonKey(name: 'date_to')
  final DateTime endDate;
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
  final ParcelDto parcelDto;
  @JsonKey(name: 'payment')
  final PaymentDto payment;
  @JsonKey(name: 'is_cancellable')
  final bool isCancellable;

  ReservationDto({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numberOfAdults,
    required this.numberOfChildren,
    this.comments,
    required this.account,
    required this.car,
    required this.parcelDto,
    required this.payment,
    required this.isCancellable,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);

  factory ReservationDto.fromEntity(Reservation reservation) => ReservationDto(
        id: reservation.id,
        startDate: reservation.startDate,
        endDate: reservation.endDate,
        numberOfAdults: reservation.numberOfAdults,
        numberOfChildren: reservation.numberOfChildren,
        comments: reservation.comments,
        account: AccountDto.fromEntity(reservation.account, null),
        car: CarDto.fromEntity(reservation.car),
        parcelDto: ParcelDto.fromEntity(reservation.parcel),
        payment: PaymentDto.fromEntity(reservation.payment),
        isCancellable: reservation.isCancellable,
      );

  Reservation toEntity() => Reservation(
        id: id,
        startDate: startDate,
        endDate: endDate,
        numberOfAdults: numberOfAdults,
        numberOfChildren: numberOfChildren,
        comments: comments,
        account: account.toEntity(),
        car: car.toEntity(),
        parcel: parcelDto.toEntity(),
        payment: payment.toEntity(),
        isCancellable: isCancellable,
      );
}
