import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/data/data_sources/reservation_api_service.dart';
import 'package:campngo/features/reservations/data/models/create_reservation_request_dto.dart';
import 'package:campngo/features/reservations/data/models/update_reservation_request_dto.dart';
import 'package:campngo/features/reservations/data/repository_impl/reservation_repository_mock.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:dio/dio.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationApiService _reservationApiService;
  final bool useMocks; // Add a flag to control mock usage
  final ReservationRepositoryMock _reservationRepositoryMock =
      ReservationRepositoryMock();

  ReservationRepositoryImpl(this._reservationApiService,
      {this.useMocks = false});

  @override
  Future<Result<Parcel, Exception>> getParcelDetails(
      {required String reservationId}) async {
    if (useMocks) {
      return _reservationRepositoryMock.getParcelDetails(
          reservationId: reservationId);
    } else {
      // Real API implementation
      try {
        //TODO change to parcelNumber
        final httpResponse = await _reservationApiService.getParcelDetails(
            parcelNumber: int.parse(reservationId));

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
  }

  @override
  Future<Result<PaginatedResponse<Parcel>, Exception>> getParcelList({
    required DateTime startDate,
    required DateTime endDate,
    required int adults,
    required int children,
    required int page,
  }) async {
    if (useMocks) {
      // Obsługa mocków (przykład dla testów)
      return _reservationRepositoryMock.getParcelList(
        startDate: startDate,
        endDate: endDate,
        adults: adults,
        children: children,
        page: page,
      );
    } else {
      try {
        final httpResponse = await _reservationApiService.getAvailableParcels(
          startDate: startDate,
          endDate: endDate,
          adults: adults,
          children: children,
          page: page,
        );

        if (httpResponse.response.statusCode == HttpStatus.ok) {
          final response = PaginatedResponse<Parcel>(
            items:
                httpResponse.data.parcels.map((dto) => dto.toEntity()).toList(),
            currentPage: httpResponse.data.currentPage,
            itemsPerPage: httpResponse.data.itemsPerPage,
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
  }

  @override
  Future<Result<Reservation, Exception>> getReservationDetails({
    required String reservationId,
  }) async {
    if (useMocks) {
      return _reservationRepositoryMock.getReservationDetails(
          reservationId: reservationId);
    } else {
      // Real API implementation
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
  }

  @override
  Future<Result<PaginatedResponse<ReservationPreview>, Exception>>
      getReservationList({required String userId, required int page}) async {
    if (useMocks) {
      return _reservationRepositoryMock.getReservationList(
        userId: userId,
        page: 1,
      );
    } else {
      // Real API implementation
      try {
        final httpResponse = await _reservationApiService.getMyReservations(
            userId: userId, page: page);

        if (httpResponse.response.statusCode == HttpStatus.ok ||
            httpResponse.response.statusCode == 200) {
          final PaginatedResponse<ReservationPreview> paginatedResponse =
              PaginatedResponse<ReservationPreview>(
            currentPage: httpResponse.data.currentPage,
            totalItems: httpResponse.data.totalItems,
            itemsPerPage: httpResponse.data.itemsPerPage,
            items:
                httpResponse.data.items.map((dto) => dto.toEntity()).toList(),
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
  }

  @override
  Future<Result<void, Exception>> createReservation(
      {required int parcelNumber,
      required int adults,
      required int children,
      required DateTime startDate,
      required DateTime endDate,
      required String carRegistration}) async {
    try {
      final httpResponse = await _reservationApiService.createReservation(
          createReservationRequestDto: CreateReservationRequestDto(
              parcelNumber: parcelNumber,
              adults: adults,
              children: children,
              startDate: startDate,
              endDate: endDate,
              carRegistration: carRegistration));

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        return const Success(null);
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
      {required String reservationId,
      DateTime? startDate,
      DateTime? endDate,
      String? phoneNumber,
      String? carRegistration}) async {
    try {
      final httpResponse = await _reservationApiService.updateReservation(
          reservationId: reservationId,
          updateReservationRequestDto: UpdateReservationRequestDto(
              startDate: startDate,
              endDate: endDate,
              phoneNumber: phoneNumber,
              carRegistration: carRegistration));

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
