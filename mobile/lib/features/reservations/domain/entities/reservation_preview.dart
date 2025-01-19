import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/payment.dart';
import 'package:equatable/equatable.dart';

class ReservationPreview extends Equatable {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final Parcel parcel;
  final Payment payment;
  final ReservationPreviewMetadata metadata;

  bool get canCancel => metadata.isCancellable;
  bool get canBeEdited => metadata.isCarModifiable;

  const ReservationPreview({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.parcel,
    required this.payment,
    required this.metadata,
  });

  ReservationPreview copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    Parcel? parcel,
    Payment? payment,
    ReservationPreviewMetadata? metadata,
  }) =>
      ReservationPreview(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        parcel: parcel ?? this.parcel,
        payment: payment ?? this.payment,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        parcel,
        payment,
        metadata,
      ];
}

class ReservationPreviewMetadata extends Equatable {
  final bool isCancellable;
  final bool isCarModifiable;

  const ReservationPreviewMetadata({
    required this.isCancellable,
    required this.isCarModifiable,
  });

  ReservationPreviewMetadata copyWith({
    bool? isCancellable,
    bool? isCarModifiable,
  }) =>
      ReservationPreviewMetadata(
        isCancellable: isCancellable ?? this.isCancellable,
        isCarModifiable: isCarModifiable ?? this.isCarModifiable,
      );

  @override
  List<Object?> get props => [
        isCancellable,
        isCarModifiable,
      ];
}
