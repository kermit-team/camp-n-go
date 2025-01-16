import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/payment.dart';
import 'package:equatable/equatable.dart';

class ReservationPreview extends Equatable {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final Parcel parcel;
  final Payment payment;
  final bool canCancel;

  const ReservationPreview({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.parcel,
    required this.payment,
    required this.canCancel,
  });

  ReservationPreview copyWith({
    String? reservationId,
    DateTime? startDate,
    DateTime? endDate,
    Parcel? parcel,
    Payment? payment,
    bool? canCancel,
  }) =>
      ReservationPreview(
        id: reservationId ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        parcel: parcel ?? this.parcel,
        payment: payment ?? this.payment,
        canCancel: canCancel ?? this.canCancel,
      );

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        parcel,
        payment,
        canCancel,
      ];
}
