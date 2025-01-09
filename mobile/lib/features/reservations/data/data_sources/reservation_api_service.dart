import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/data/models/available_parcels_response_dto.dart';
import 'package:campngo/features/reservations/data/models/create_reservation_request_dto.dart';
import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/data/models/reservation_dto.dart';
import 'package:campngo/features/reservations/data/models/reservation_preview_dto.dart';
import 'package:campngo/features/reservations/data/models/update_reservation_request_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class ReservationApiService {
  factory ReservationApiService(Dio dio) = _ReservationApiService;

  // GET EP widok dostępnych parceli
  @GET("/parcels/")
  Future<HttpResponse<AvailableParcelsResponseDto>> getAvailableParcels({
    @Query("start_date") required DateTime startDate,
    @Query("end_date") required DateTime endDate,
    @Query("adults") required int adults,
    @Query("children") required int children,
    @Query("page") required int page,
  });

  // POST EP Rezerwacja parceli
  @POST("/reservations/")
  Future<HttpResponse<void>> createReservation({
    @Body() required CreateReservationRequestDto createReservationRequestDto,
  });

  // GET EP moje rezerwacje
  @GET("/reservations/user/")
  Future<HttpResponse<PaginatedResponse<ReservationPreviewDto>>>
      getMyReservations({
    @Query("page") required int page,
    @Query("user_id") required String userId,
  });

  // GET EP dane parceli
  @GET("/parcels/{parcel_number}/")
  Future<HttpResponse<ParcelDto>> getParcelDetails({
    @Path("parcel_number") required int parcelNumber,
  });

  // GET EP dane rezerwacji
  @GET("/reservations/{reservation_id}/")
  Future<HttpResponse<ReservationDto>> getReservationDetails({
    @Path("reservation_id") required String reservationId,
  });

  // PATCH EP edycja rezeracji
  @PATCH("/reservations/{reservation_id}/")
  Future<HttpResponse<void>> updateReservation({
    @Path("reservation_id") required String reservationId,
    @Body() required UpdateReservationRequestDto updateReservationRequestDto,
  });

  @DELETE("/reservations/{reservation_id}/")
  Future<HttpResponse<void>> cancelReservation({
    @Path('reservationId') required String reservationId,
  });
}
