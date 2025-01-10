import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:equatable/equatable.dart';

class Reservation extends Equatable {
  final String id;
  final Parcel parcel;
  final Account account;
  final int numberOfNights;
  final int adults;
  final int children;
  final DateTime startDate;
  final DateTime endDate;
  final Car car;
  final bool canBeEdited;

  const Reservation({
    required this.id,
    required this.parcel,
    required this.account,
    required this.numberOfNights,
    required this.adults,
    required this.children,
    required this.startDate,
    required this.endDate,
    required this.car,
    this.canBeEdited = false,
  });

  Reservation copyWith({
    String? id,
    Parcel? parcel,
    Account? account,
    int? numberOfNights,
    int? adults,
    int? children,
    DateTime? startDate,
    DateTime? endDate,
    Car? car,
    bool? canBeEdited,
  }) =>
      Reservation(
        id: id ?? this.id,
        parcel: parcel ?? this.parcel,
        account: account ?? this.account,
        numberOfNights: numberOfNights ?? this.numberOfNights,
        adults: adults ?? this.adults,
        children: children ?? this.children,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        car: car ?? this.car,
        canBeEdited: canBeEdited ?? this.canBeEdited,
      );

  @override
  List<Object?> get props => [
        id,
        parcel,
        account,
        numberOfNights,
        adults,
        children,
        startDate,
        endDate,
        car,
        canBeEdited,
      ];
}
