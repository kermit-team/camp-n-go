import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:campngo/features/shared/token_decoder.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_review_state.dart';

class ReservationReviewCubit extends Cubit<ReservationReviewState> {
  final ReservationRepository reservationRepository;
  final AccountSettingsRepository accountSettingsRepository;

  ReservationReviewCubit({
    required this.reservationRepository,
    required this.accountSettingsRepository,
  }) : super(const ReservationReviewState());

  /// Pobiera dane rezerwacji na podstawie ID
  Future<void> getReservationData(String reservationId) async {
    emit(state.copyWith(reservationStatus: SubmissionStatus.loading));

    try {
      final reservationResult =
          await reservationRepository.getReservationDetails(
        reservationId: reservationId,
      );
      if (reservationResult is Success<Reservation, Exception>) {
        emit(state.copyWith(
          reservationStatus: SubmissionStatus.success,
          reservation: reservationResult.value,
        ));
      }

      emit(state.copyWith(
        reservationStatus: SubmissionStatus.failure,
        exception: Exception("Coś poszło nie tak"),
      ));
    } on DioException catch (dioException) {
      emit(state.copyWith(
        exception: dioException,
        reservationStatus: SubmissionStatus.failure,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        reservationStatus: SubmissionStatus.failure,
        exception: error,
      ));
    }
  }

  /// Pobiera dane użytkownika na podstawie jego ID
  Future<void> getUserData() async {
    emit(state.copyWith(userStatus: SubmissionStatus.loading));

    try {
      final token = await serviceLocator<TokenStorage>().getAccessToken();
      if (token != null) {
        final identifier = TokenDecoder.getUserId(
          token: token,
        );

        final Result<Account, Exception> result =
            await accountSettingsRepository.getAccountData(
          identifier: identifier,
        );
        switch (result) {
          case Success<Account, Exception>(
              value: Account accountEntity,
            ):
            {
              emit(state.copyWith(
                userStatus: SubmissionStatus.success,
                user: accountEntity,
              ));
              break;
            }
          case Failure<Account, Exception>(exception: final exception):
            {
              emit(state.copyWith(
                userStatus: SubmissionStatus.failure,
                exception: exception,
              ));
            }
        }
      }
    } catch (error) {
      emit(state.copyWith(
        userStatus: SubmissionStatus.failure,
        exception: error as Exception,
      ));
    }
  }

  Future<void> fetchReservationReview(String reservationId) async {
    await getReservationData(reservationId);
    if (state.reservationStatus == SubmissionStatus.success &&
        state.reservation != null) {
      await getUserData();
      // await fetchUser(state.reservation!.ownerId);
    }
  }
}
