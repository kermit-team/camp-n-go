import 'dart:developer';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parcel_list_state.dart';

class ParcelListCubit extends Cubit<ParcelListState> {
  final ReservationRepository reservationRepository;

  ParcelListCubit({required this.reservationRepository})
      : super(const ParcelListState());

  Future<void> getParcelList({
    required GetParcelListParams params,
    required int page,
  }) async {
    if (page == 1) {
      emit(state.copyWith(
        getParcelListStatus: SubmissionStatus.loading,
        currentPage: 1,
        parcels: [],
        hasMoreParcels: true,
        params: params,
      ));
    }

    try {
      final Result<PaginatedResponse<Parcel>, Exception> result =
          await reservationRepository.getParcelList(
        page: page,
        startDate: params.startDate,
        endDate: params.endDate,
        adults: params.adults,
        children: params.children,
      );

      switch (result) {
        case Success<PaginatedResponse<Parcel>, Exception>():
          List<Parcel> updatedList = List.of(state.parcels ?? []);
          if (page > 1) {
            updatedList.addAll(result.value.items);
          } else {
            updatedList = result.value.items;
          }

          emit(state.copyWith(
            getParcelListStatus: SubmissionStatus.success,
            parcels: updatedList,
            currentPage: page,
            parcelsPerPage: result.value.itemsPerPage,
            totalParcels: result.value.totalItems,
            hasMoreParcels: page <
                (result.value.totalItems / result.value.itemsPerPage).ceil(),
          ));
          break;

        case Failure<PaginatedResponse<Parcel>, Exception>():
          log('[getParcelList bloc error result]: ${result.exception.toString()}');
          emit(state.copyWith(
            getParcelListStatus: SubmissionStatus.failure,
            exception: result.exception,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        getParcelListStatus: SubmissionStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        getParcelListStatus: SubmissionStatus.failure,
        exception: exception,
      ));
    }
  }

  void resetState() {
    emit(const ParcelListState());
  }
}
