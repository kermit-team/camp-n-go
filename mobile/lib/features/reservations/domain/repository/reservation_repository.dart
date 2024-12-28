import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_entity.dart';

abstract class ReservationRepository {
  Future<Result<List<ParcelEntity>, Exception>> getParcelList({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Result<List<ReservationEntity>, Exception>> getReservationList({
    required String userId,
  });

  Future<Result<ReservationEntity, Exception>> getParcelDetails({
    required String reservationId,
  });

  Future<Result<ReservationEntity, Exception>> getReservationDetails({
    required String reservationId,
  });
}
