import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:equatable/equatable.dart';

class Reservation extends Equatable {
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
  final List<Car> cars;

  const Reservation({
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

  copyWith({
    int? parcelNumber,
    String? sector,
    int? numberOfNights,
    int? adults,
    int? children,
    DateTime? startDate,
    DateTime? endDate,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? idCard,
    List<Car>? cars,
  }) =>
      Reservation(
        parcelNumber: parcelNumber ?? this.parcelNumber,
        sector: sector ?? this.sector,
        numberOfNights: numberOfNights ?? this.numberOfNights,
        adults: adults ?? this.adults,
        children: children ?? this.children,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        idCard: idCard ?? this.idCard,
        cars: cars ?? this.cars,
      );

  @override
  List<Object?> get props => [
        parcelNumber,
        sector,
        numberOfNights,
        adults,
        children,
        startDate,
        endDate,
        firstName,
        lastName,
        email,
        phoneNumber,
        idCard,
        cars,
      ];
}
