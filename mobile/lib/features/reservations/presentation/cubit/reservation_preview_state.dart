part of 'reservation_preview_cubit.dart';

class ReservationPreviewState extends Equatable {
  final SubmissionStatus getReservationStatus;
  final SubmissionStatus editCarStatus;
  final Reservation? reservation;
  final Account? user;
  final Exception? exception;

  const ReservationPreviewState({
    this.getReservationStatus = SubmissionStatus.initial,
    this.editCarStatus = SubmissionStatus.initial,
    this.reservation,
    this.user,
    this.exception,
  });

  ReservationPreviewState copyWith({
    SubmissionStatus? getReservationStatus,
    SubmissionStatus? editCarStatus,
    Reservation? reservation,
    Account? user,
    Exception? exception,
  }) {
    return ReservationPreviewState(
      getReservationStatus: getReservationStatus ?? this.getReservationStatus,
      editCarStatus: editCarStatus ?? this.editCarStatus,
      reservation: reservation ?? this.reservation,
      user: user ?? this.user,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        getReservationStatus,
        editCarStatus,
        reservation,
        user,
        exception,
      ];
}
