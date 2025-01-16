import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:campngo/features/shared/token_decoder.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_summary_state.dart';

class ReservationSummaryCubit extends Cubit<ReservationSummaryState> {
  final ReservationRepository reservationRepository;
  final AccountSettingsRepository accountSettingsRepository;

  ReservationSummaryCubit({
    required this.reservationRepository,
    required this.accountSettingsRepository,
  }) : super(const ReservationSummaryState(
            getUserDataStatus: SubmissionStatus.initial));

  getAccountData() async {
    emit(const ReservationSummaryState(
      getUserDataStatus: SubmissionStatus.loading,
    ));

    try {
      final token = await serviceLocator<TokenStorage>().getAccessToken();

      if (token != null) {
        final userId = TokenDecoder.getUserId(
          token: token,
        );

        final Result<Account, Exception> result =
            await accountSettingsRepository.getAccountData(identifier: userId);

        switch (result) {
          case Success<Account, Exception>(
              value: Account accountEntity,
            ):
            {
              emit(state.copyWith(
                getUserDataStatus: SubmissionStatus.success,
                account: accountEntity,
                carList: accountEntity.carList,
              ));
              break;
            }
          case Failure<Account, Exception>(exception: final exception):
            {
              emit(state.copyWith(
                getUserDataStatus: SubmissionStatus.failure,
                exception: exception,
              ));
            }
        }
      } else {}
    } on DioException catch (dioException) {
      emit(state.copyWith(
        getUserDataStatus: SubmissionStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        getUserDataStatus: SubmissionStatus.failure,
        exception: exception,
      ));
    }
  }

  assignCarToReservation({required Car carToAssign}) {
    if (state.carList != null) {
      List<Car> cars = [];
      //settings all cars to not assigned
      for (final car in state.carList!) {
        cars.add(
          Car(
            id: car.id,
            registrationPlate: car.registrationPlate,
          ),
        );
      }
      final car = cars.firstWhere(
          (c) => c.registrationPlate == carToAssign.registrationPlate);
      final index = cars.indexOf(car);
      final updatedCar = Car(
        id: car.id,
        registrationPlate: car.registrationPlate,
      );
      cars[index] = updatedCar;

      emit(state.copyWith(
        carList: cars,
        assignedCar: carToAssign,
      ));
    }
  }

  // Future<void> makeReservation() async {
  //   emit(const ReservationSummaryState(
  //     getUserDataStatus: SubmissionStatus.loading,
  //   ));
  //
  //   try {
  //     final Result<String, Exception> result =
  //         await reservationRepository.makeReservation();
  //
  //     switch (result) {
  //       case Success<String, Exception>():
  //         emit(
  //           state.copyWith(reservationStatus: SubmissionStatus.success),
  //         );
  //       case Failure<String, Exception>(exception: final exception):
  //         emit(state.copyWith(
  //           reservationStatus: SubmissionStatus.failure,
  //           exception: exception,
  //         ));
  //     }
  //   } on DioException catch (dioException) {
  //     emit(state.copyWith(
  //       getUserDataStatus: SubmissionStatus.failure,
  //       exception: dioException,
  //     ));
  //   } on Exception catch (exception) {
  //     emit(state.copyWith(
  //       getUserDataStatus: SubmissionStatus.failure,
  //       exception: exception,
  //     ));
  //   }
  // }
}
