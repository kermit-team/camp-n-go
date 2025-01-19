import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:campngo/features/reservations/domain/entities/reservation.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';

abstract class ReservationRepository {
  Future<Result<Parcel, Exception>> getParcelDetails({
    required int parcelId,
  });

  Future<Result<PaginatedResponse<ParcelListItem>, Exception>> getParcelList({
    required DateTime startDate,
    required DateTime endDate,
    required int adults,
    required int children,
    required int page,
    required int pageSize,
  });

  Future<Result<Reservation, Exception>> getReservationDetails({
    required int reservationId,
  });

  Future<Result<PaginatedResponse<ReservationPreview>, Exception>>
      getReservationList({
    required String userId,
    required int page,
    required int pageSize,
  });

  Future<Result<String, Exception>> createReservation({
    required int parcelId,
    required int adults,
    required int children,
    required int carId,
    required DateTime startDate,
    required DateTime endDate,
    String? comments,
  });

  Future<Result<void, Exception>> updateReservation({
    required int reservationId,
    DateTime? startDate,
    DateTime? endDate,
    String? phoneNumber,
    String? carRegistration,
  });

  Future<Result<void, Exception>> cancelReservation({
    required int reservationId,
  });

  Future<Result<void, Exception>> editCar({
    required int reservationId,
    required int carId,
  });
}
