import 'package:campngo/features/account_settings/data/models/account_dto.dart';
import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_dto.g.dart';

@JsonSerializable()
class ReservationDto {
  final String id;
  final ParcelDto parcel;
  final AccountDto account;
  final int numberOfNights;
  final int adults;
  final int children;
  final DateTime startDate;
  final DateTime endDate;
  final CarDto car;

  ReservationDto({
    required this.id,
    required this.parcel,
    required this.account,
    required this.numberOfNights,
    required this.adults,
    required this.children,
    required this.startDate,
    required this.endDate,
    required this.car,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);

  factory ReservationDto.fromEntity(Reservation reservation) => ReservationDto(
        id: reservation.id,
        parcel: ParcelDto.fromEntity(reservation.parcel),
        account: AccountDto.fromEntity(reservation.account, null),
        numberOfNights: reservation.numberOfNights,
        adults: reservation.adults,
        children: reservation.children,
        startDate: reservation.startDate,
        endDate: reservation.endDate,
        car: CarDto.fromEntity(reservation.car),
      );

  Reservation toEntity() => Reservation(
        id: id,
        parcel: parcel.toEntity(),
        account: account.toEntity(),
        numberOfNights: numberOfNights,
        adults: adults,
        children: children,
        startDate: startDate,
        endDate: endDate,
        car: car.toEntity(),
      );
}
