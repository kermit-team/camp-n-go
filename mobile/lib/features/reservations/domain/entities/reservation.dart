// reservation.dart

import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/payment.dart';
import 'package:equatable/equatable.dart';

class Reservation extends Equatable {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfAdults;
  final int numberOfChildren;
  final String? comments;
  final Account account;
  final Car car;
  final Parcel parcel;
  final Payment payment;
  final ReservationMetadata metadata;

  bool get isCancellable => metadata.isCancellable;
  bool get isCarModifiable => metadata.isCarModifiable;

  const Reservation({
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

  Reservation copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfAdults,
    int? numberOfChildren,
    String? comments,
    Account? account,
    Car? car,
    Parcel? parcel,
    Payment? payment,
    ReservationMetadata? metadata,
  }) =>
      Reservation(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        numberOfAdults: numberOfAdults ?? this.numberOfAdults,
        numberOfChildren: numberOfChildren ?? this.numberOfChildren,
        comments: comments ?? this.comments,
        account: account ?? this.account,
        car: car ?? this.car,
        parcel: parcel ?? this.parcel,
        payment: payment ?? this.payment,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        numberOfAdults,
        numberOfChildren,
        comments,
        account,
        car,
        parcel,
        payment,
        metadata,
      ];
}

class ReservationMetadata extends Equatable {
  final bool isCancellable;
  final bool isCarModifiable;

  const ReservationMetadata({
    required this.isCancellable,
    required this.isCarModifiable,
  });

  ReservationMetadata copyWith({
    bool? isCancellable,
    bool? isCarModifiable,
  }) =>
      ReservationMetadata(
        isCancellable: isCancellable ?? this.isCancellable,
        isCarModifiable: isCarModifiable ?? this.isCarModifiable,
      );

  @override
  List<Object?> get props => [
        isCancellable,
        isCarModifiable,
      ];
}
