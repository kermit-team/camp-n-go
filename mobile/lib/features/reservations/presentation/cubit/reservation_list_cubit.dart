import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:campngo/features/shared/token_decoder.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_list_state.dart';

class ReservationListCubit extends Cubit<ReservationListState> {
  final ReservationRepository reservationRepository;

  ReservationListCubit({required this.reservationRepository})
      : super(const ReservationListState());

  Future<void> getReservationList({
    required int page,
  }) async {
    if (page == 1) {
      emit(state.copyWith(
        getReservationListStatus: SubmissionStatus.loading,
        cancelReservationStatus: SubmissionStatus.initial,
        currentPage: 1,
        reservations: [],
        hasMoreItems: true,
      ));
    }
    final token = await serviceLocator<TokenStorage>().getAccessToken();
    final String? userId =
        token != null ? TokenDecoder.getUserId(token: token) : null;

    if (userId != null) {
      try {
        final Result<PaginatedResponse<ReservationPreview>, Exception> result =
            await reservationRepository.getReservationList(
          userId: userId,
          page: page,
          pageSize: Constants.pageSize,
        );

        switch (result) {
          case Success<PaginatedResponse<ReservationPreview>, Exception>():
            List<ReservationPreview> updatedList =
                List.of(state.reservations ?? []);
            if (page > 1) {
              updatedList.addAll(result.value.items);
            } else {
              updatedList = result.value.items;
            }

            emit(state.copyWith(
              getReservationListStatus: SubmissionStatus.success,
              reservations: updatedList,
              currentPage: page,
              totalItems: result.value.totalItems,
              hasMoreItems:
                  page < (result.value.totalItems / Constants.pageSize).ceil(),
            ));
            break;

          case Failure<PaginatedResponse<ReservationPreview>, Exception>():
            log('[getReservationList bloc error result]: ${result.exception.toString()}');
            emit(state.copyWith(
              getReservationListStatus: SubmissionStatus.failure,
              exception: result.exception,
            ));
        }
      } on DioException catch (dioException) {
        emit(state.copyWith(
          getReservationListStatus: SubmissionStatus.failure,
          exception: dioException,
        ));
      } on Exception catch (exception) {
        emit(
          state.copyWith(
            getReservationListStatus: SubmissionStatus.failure,
            exception: exception,
          ),
        );
      }
    } else {
      //todo: check error handling here
      emit(
        state.copyWith(
          getReservationListStatus: SubmissionStatus.failure,
          exception: Exception('No user ID'),
        ),
      );
    }
  }

  Future<void> cancelReservation({required String reservationId}) async {
    emit(state.copyWith(cancelReservationStatus: SubmissionStatus.loading));
    try {
      final Result<void, Exception> result =
          await reservationRepository.cancelReservation(
        reservationId: reservationId,
      );

      switch (result) {
        case Success<void, Exception>():
          emit(state.copyWith(
              cancelReservationStatus: SubmissionStatus.success));
          break;
        case Failure<void, Exception>():
          emit(state.copyWith(
              cancelReservationStatus: SubmissionStatus.failure,
              exception: result.exception));
      }
      // await Future.delayed(const Duration(seconds: 1));
      // emit(state.copyWith(cancelReservationStatus: SubmissionStatus.success));
    } on DioException catch (dioException) {
      emit(state.copyWith(
          cancelReservationStatus: SubmissionStatus.failure,
          exception: dioException));
    } on Exception catch (exception) {
      emit(state.copyWith(
          cancelReservationStatus: SubmissionStatus.failure,
          exception: exception));
    }
  }

  void resetState() {
    emit(const ReservationListState());
  }
}
