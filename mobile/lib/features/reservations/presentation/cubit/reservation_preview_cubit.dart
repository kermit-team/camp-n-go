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
  Future<void> getReservationData({required String reservationId}) async {
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
}

// /// Pobiera dane użytkownika na podstawie jego ID
// Future<void> getUserData() async {
//   emit(state.copyWith(userStatus: SubmissionStatus.loading));
//
//   try {
//     final token = await serviceLocator<TokenStorage>().getAccessToken();
//     if (token != null) {
//       final identifier = TokenDecoder.getUserId(
//         token: token,
//       );
//
//       final Result<Account, Exception> result =
//           await accountSettingsRepository.getAccountData(
//         identifier: identifier,
//       );
//       switch (result) {
//         case Success<Account, Exception>(
//             value: Account accountEntity,
//           ):
//           {
//             emit(state.copyWith(
//               userStatus: SubmissionStatus.success,
//               user: accountEntity,
//             ));
//             break;
//           }
//         case Failure<Account, Exception>(exception: final exception):
//           {
//             emit(state.copyWith(
//               userStatus: SubmissionStatus.failure,
//               exception: exception,
//             ));
//           }
//       }
//     }
//   } catch (error) {
//     emit(state.copyWith(
//       userStatus: SubmissionStatus.failure,
//       exception: error as Exception,
//     ));
//   }
// }

// Future<void> fetchReservationPreview(String reservationId) async {
//   await getReservationData(reservationId);
//   if (state.getReservationStatus == SubmissionStatus.success &&
//       state.reservation != null) {
//     await getUserData();
//     // await fetchUser(state.reservation!.ownerId);
//   }
// }
