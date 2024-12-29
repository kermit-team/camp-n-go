import 'package:equatable/equatable.dart';

class ReservationPreview extends Equatable {
  final int parcelNumber;
  final double reservationPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String sector;
  final String reservationStatus;
  final bool canCancel;

  const ReservationPreview({
    required this.parcelNumber,
    required this.reservationPrice,
    required this.startDate,
    required this.endDate,
    required this.sector,
    required this.reservationStatus,
    required this.canCancel,
  });

  copyWith({
    int? parcelNumber,
    double? reservationPrice,
    DateTime? startDate,
    DateTime? endDate,
    String? sector,
    String? reservationStatus,
    bool? canCancel,
  }) =>
      ReservationPreview(
        parcelNumber: parcelNumber ?? this.parcelNumber,
        reservationPrice: reservationPrice ?? this.reservationPrice,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        sector: sector ?? this.sector,
        reservationStatus: reservationStatus ?? this.reservationStatus,
        canCancel: canCancel ?? this.canCancel,
      );

  @override
  List<Object?> get props => [
        parcelNumber,
        reservationPrice,
        startDate,
        endDate,
        sector,
        reservationStatus,
        canCancel,
      ];
}
