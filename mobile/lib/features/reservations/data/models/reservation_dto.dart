import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_dto.g.dart';

@JsonSerializable()
class ReservationDto {
  final int parcelNumber;
  final String sector;
  final int numberOfNights;
  final int adults;
  final int children;
  final DateTime startDate;
  final DateTime endDate;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String idCard;
  final List<CarDto> cars;

  ReservationDto({
    required this.parcelNumber,
    required this.sector,
    required this.numberOfNights,
    required this.adults,
    required this.children,
    required this.startDate,
    required this.endDate,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.idCard,
    required this.cars,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);

  factory ReservationDto.fromEntity(Reservation reservation) => ReservationDto(
        parcelNumber: reservation.parcelNumber,
        sector: reservation.sector,
        numberOfNights: reservation.numberOfNights,
        adults: reservation.adults,
        children: reservation.children,
        startDate: reservation.startDate,
        endDate: reservation.endDate,
        firstName: reservation.firstName,
        lastName: reservation.lastName,
        email: reservation.email,
        phoneNumber: reservation.phoneNumber,
        idCard: reservation.idCard,
        cars: reservation.cars.map((car) => CarDto.fromEntity(car)).toList(),
      );

  Reservation toEntity() => Reservation(
        parcelNumber: parcelNumber,
        sector: sector,
        numberOfNights: numberOfNights,
        adults: adults,
        children: children,
        startDate: startDate,
        endDate: endDate,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        idCard: idCard,
        cars: cars.map((carDto) => carDto.toEntity()).toList(),
      );
}
