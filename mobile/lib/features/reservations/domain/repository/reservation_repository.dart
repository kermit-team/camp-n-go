import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';

abstract class ReservationRepository {
  Future<Result<Parcel, Exception>> getParcelDetails({
    required String reservationId,
  });

  Future<Result<PaginatedResponse<Parcel>, Exception>> getParcelList({
    required DateTime startDate,
    required DateTime endDate,
    required int adults,
    required int children,
    required int page,
  });

  Future<Result<Reservation, Exception>> getReservationDetails({
    required String reservationId,
  });

  Future<Result<PaginatedResponse<ReservationPreview>, Exception>>
      getReservationList({
    required String userId,
    required int page,
  });

  Future<Result<void, Exception>> createReservation({
    required int parcelNumber,
    required int adults,
    required int children,
    required DateTime startDate,
    required DateTime endDate,
    required String carRegistration,
  });

  Future<Result<void, Exception>> updateReservation({
    required String reservationId,
    DateTime? startDate,
    DateTime? endDate,
    String? phoneNumber,
    String? carRegistration,
  });
}
