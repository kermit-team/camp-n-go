import 'dart:developer';
import 'dart:io';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/data/data_sources/reservation_api_service.dart';
import 'package:campngo/features/reservations/data/models/create_reservation_request_dto.dart';
import 'package:campngo/features/reservations/data/models/update_reservation_request_dto.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:dio/dio.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationApiService _reservationApiService;

  ReservationRepositoryImpl(
    this._reservationApiService,
  );

  @override
  Future<Result<Parcel, Exception>> getParcelDetails({
    required int parcelId,
  }) async {
    // Real API implementation
    try {
      final httpResponse = await _reservationApiService.getParcelDetails(
        id: parcelId,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final Parcel parcel = httpResponse.data.toEntity();
        return Success(parcel);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>getParcelDetails]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<PaginatedResponse<ParcelListItem>, Exception>> getParcelList({
    required DateTime startDate,
    required DateTime endDate,
    required int adults,
    required int children,
    required int page,
    required int pageSize,
  }) async {
    try {
      final httpResponse = await _reservationApiService.getAvailableParcels(
        dateFrom: startDate.toDateString(),
        dateTo: endDate.toDateString(),
        numberOfAdults: adults,
        numberOfChildren: children,
        page: page,
        pageSize: Constants.pageSize,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final response = PaginatedResponse<ParcelListItem>(
          items:
              httpResponse.data.parcels.map((dto) => dto.toEntity()).toList(),
          currentPage: httpResponse.data.currentPage,
          totalItems: httpResponse.data.totalItems,
        );
        return Success(response);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>getParcelList]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<Reservation, Exception>> getReservationDetails({
    required int reservationId,
  }) async {
    try {
      final httpResponse = await _reservationApiService.getReservationDetails(
          reservationId: reservationId);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final Reservation reservation = httpResponse.data.toEntity();
        return Success(reservation);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>getReservationDetails]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<PaginatedResponse<ReservationPreview>, Exception>>
      getReservationList({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    // Real API implementation
    try {
      final httpResponse = await _reservationApiService.getMyReservations(
        page: page,
        pageSize: pageSize,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final PaginatedResponse<ReservationPreview> paginatedResponse =
            PaginatedResponse<ReservationPreview>(
          currentPage: httpResponse.data.currentPage,
          totalItems: httpResponse.data.totalItems,
          items: httpResponse.data.items.map((dto) => dto.toEntity()).toList(),
        );
        return Success(paginatedResponse);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>getReservationList]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<String, Exception>> createReservation({
    required int parcelId,
    required int adults,
    required int children,
    required int carId,
    required DateTime startDate,
    required DateTime endDate,
    String? comments,
  }) async {
    try {
      final httpResponse = await _reservationApiService.createReservation(
          createReservationRequestDto: CreateReservationRequestDto(
        startDate: startDate.toDateString(),
        endDate: endDate.toDateString(),
        numberOfAdults: adults,
        numberOfChildren: children,
        carId: carId,
        parcelId: parcelId,
        comments: comments,
      ));

      if (httpResponse.response.statusCode == HttpStatus.created ||
          httpResponse.response.statusCode == 201) {
        return Success(httpResponse.data.stripeUrl);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>createReservation]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<void, Exception>> updateReservation(
      {required int reservationId,
      DateTime? startDate,
      DateTime? endDate,
      String? phoneNumber,
      String? carRegistration}) async {
    try {
      final httpResponse = await _reservationApiService.updateReservation(
          reservationId: reservationId,
          updateReservationRequestDto: UpdateReservationRequestDto(
            carRegistration: carRegistration,
          ));

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        return const Success(null);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>updateReservation]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<void, Exception>> cancelReservation(
      {required int reservationId}) async {
    try {
      final httpResponse = await _reservationApiService.cancelReservation(
        reservationId: reservationId,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        return const Success(null);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>cancelReservation]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<void, Exception>> editCar({
    required int reservationId,
    required int carId,
  }) async {
    try {
      final httpResponse = await _reservationApiService.editCar(
        reservationId: reservationId,
        carId: {"car": carId},
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        return const Success(null);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[ReservationRepositoryImpl>editCar]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  Exception handleError(Response response) {
    String errorText = "";
    if (response.data is Map) {
      response.data.forEach((key, value) {
        errorText += "$value";
        log('Key: $key');
        log('Value: $value');
      });
    } else {
      errorText = response.data.toString();
    }

    log('Dio Register error details: ${response.data}');
    return Exception(errorText);
  }

  Exception handleApiError(DioException dioException) {
    if (dioException.response != null) {
      String errorText = "";
      if (dioException.response!.data is Map) {
        dioException.response!.data.forEach((key, value) {
          errorText += "$value";
          log('Key: $key');
          log('Value: $value');
        });
      } else {
        errorText = dioException.response!.data.toString();
      }

      log('Dio Register error details: ${dioException.response!.data}');
      return DioException(
        message: errorText,
        requestOptions: dioException.requestOptions,
      );
    } else if (dioException.message != null) {
      log('Dio Register error details: ${dioException.message}');
      return Exception(dioException.message);
    }

    return Exception(dioException.message);
  }
}
