import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final ParcelEntity parcel;
  final DateTime startDate;
  final DateTime endDate;
  final String ownerId;
  final String phoneNumber;
  final String carIdentifier;

  const ReservationEntity({
    required this.parcel,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    required this.phoneNumber,
    required this.carIdentifier,
  });

  @override
  List<Object?> get props => [];
}
