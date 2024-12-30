part of 'reservation_summary_cubit.dart';

class ReservationSummaryState extends Equatable {
  final SubmissionStatus getUserDataStatus;
  final Account? account;
  final List<Car>? carList;
  final Car? assignedCar;
  final Exception? exception;

  const ReservationSummaryState({
    required this.getUserDataStatus,
    this.account,
    this.carList,
    this.assignedCar,
    this.exception,
  });

  copyWith({
    SubmissionStatus? getUserDataStatus,
    Account? account,
    List<Car>? carList,
    Car? assignedCar,
    Exception? exception,
  }) =>
      ReservationSummaryState(
        getUserDataStatus: getUserDataStatus ?? this.getUserDataStatus,
        account: account ?? this.account,
        carList: carList ?? this.carList,
        assignedCar: assignedCar ?? this.assignedCar,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        getUserDataStatus,
        account,
        carList,
        assignedCar,
        exception,
      ];
}
