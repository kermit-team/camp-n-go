part of 'reservation_summary_cubit.dart';

class ReservationSummaryState extends Equatable {
  final SubmissionStatus getUserDataStatus;
  final SubmissionStatus reservationStatus;
  final Account? account;
  final List<Car>? carList;
  final Car? assignedCar;
  final Exception? exception;

  const ReservationSummaryState({
    this.getUserDataStatus = SubmissionStatus.initial,
    this.reservationStatus = SubmissionStatus.initial,
    this.account,
    this.carList,
    this.assignedCar,
    this.exception,
  });

  copyWith({
    SubmissionStatus? getUserDataStatus,
    SubmissionStatus? reservationStatus,
    Account? account,
    List<Car>? carList,
    Car? assignedCar,
    Exception? exception,
  }) =>
      ReservationSummaryState(
        getUserDataStatus: getUserDataStatus ?? this.getUserDataStatus,
        reservationStatus: reservationStatus ?? this.reservationStatus,
        account: account ?? this.account,
        carList: carList ?? this.carList,
        assignedCar: assignedCar ?? this.assignedCar,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        getUserDataStatus,
        reservationStatus,
        account,
        carList,
        assignedCar,
        exception,
      ];
}
