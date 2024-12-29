part of 'reservation_review_cubit.dart';

class ReservationReviewState extends Equatable {
  final SubmissionStatus reservationStatus; // Status pobierania rezerwacji
  final SubmissionStatus userStatus; // Status pobierania danych użytkownika
  final Reservation? reservation; // Dane rezerwacji
  final Account? user; // Dane użytkownika
  final Exception? exception; // Błędy podczas pobierania danych

  const ReservationReviewState({
    this.reservationStatus = SubmissionStatus.initial,
    this.userStatus = SubmissionStatus.initial,
    this.reservation,
    this.user,
    this.exception,
  });

  ReservationReviewState copyWith({
    SubmissionStatus? reservationStatus,
    SubmissionStatus? userStatus,
    Reservation? reservation,
    Account? user,
    Exception? exception,
  }) {
    return ReservationReviewState(
      reservationStatus: reservationStatus ?? this.reservationStatus,
      userStatus: userStatus ?? this.userStatus,
      reservation: reservation ?? this.reservation,
      user: user ?? this.user,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        reservationStatus,
        userStatus,
        reservation,
        user,
        exception,
      ];
}
