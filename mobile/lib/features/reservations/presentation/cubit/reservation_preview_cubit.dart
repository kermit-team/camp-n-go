import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_preview_state.dart';

class ReservationPreviewCubit extends Cubit<ReservationPreviewState> {
  final ReservationRepository reservationRepository;

  ReservationPreviewCubit({
    required this.reservationRepository,
  }) : super(const ReservationPreviewState());

  /// Pobiera dane rezerwacji na podstawie ID
  Future<void> getReservationData({required int reservationId}) async {
    emit(state.copyWith(getReservationStatus: SubmissionStatus.loading));
    try {
      final Result<Reservation, Exception> result =
          await reservationRepository.getReservationDetails(
        reservationId: reservationId,
      );

      switch (result) {
        case Success<Reservation, Exception>():
          emit(state.copyWith(
            getReservationStatus: SubmissionStatus.success,
            reservation: result.value,
          ));
          break;
        case Failure<Reservation, Exception>():
          emit(state.copyWith(
            getReservationStatus: SubmissionStatus.failure,
            exception: result.exception,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
          getReservationStatus: SubmissionStatus.failure,
          exception: dioException));
    } on Exception catch (exception) {
      emit(state.copyWith(
          getReservationStatus: SubmissionStatus.failure,
          exception: exception));
    }
  }

  void resetGetReservationStatus() {
    emit(
      state.copyWith(getReservationStatus: SubmissionStatus.initial),
    );
  }

  void editCar({
    required int reservationId,
    required int carId,
  }) async {
    try {
      emit(state.copyWith(
        editCarStatus: SubmissionStatus.loading,
      ));

      final Result<void, Exception> result =
          await reservationRepository.editCar(
        carId: carId,
        reservationId: reservationId,
      );

      switch (result) {
        case Success<void, Exception>():
          {
            emit(state.copyWith(
              editCarStatus: SubmissionStatus.success,
            ));
            break;
          }
        case Failure<void, Exception>(exception: final exception):
          {
            emit(state.copyWith(
              editCarStatus: SubmissionStatus.failure,
              exception: exception,
            ));
          }
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        editCarStatus: SubmissionStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        editCarStatus: SubmissionStatus.failure,
        exception: exception,
      ));

      emit(state.copyWith(
        exception: Exception("[account_settings_cubit] Not implemented yet"),
        editCarStatus: SubmissionStatus.failure,
      ));
    }
  }

  void resetEditCarStatus() {
    emit(
      state.copyWith(editCarStatus: SubmissionStatus.initial),
    );
  }
}
