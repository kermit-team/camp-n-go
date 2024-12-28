import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/reservations/data/data_sources/reservation_api_service.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_entity.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationApiService reservationApiService;

  ReservationRepositoryImpl(this.reservationApiService);

  @override
  Future<Result<ReservationEntity, Exception>> getParcelDetails(
      {required String reservationId}) {
    // TODO: implement getParcelDetails
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ParcelEntity>, Exception>> getParcelList(
      {required DateTime startDate, required DateTime endDate}) {
    // TODO: implement getParcelList
    throw UnimplementedError();
  }

  @override
  Future<Result<ReservationEntity, Exception>> getReservationDetails(
      {required String reservationId}) {
    // TODO: implement getReservationDetails
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ReservationEntity>, Exception>> getReservationList(
      {required String userId}) {
    // TODO: implement getReservationList
    throw UnimplementedError();
  }
}
