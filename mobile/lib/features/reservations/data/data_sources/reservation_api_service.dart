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

  //implemented
  @GET("/camping/plots/available/")
  Future<HttpResponse<AvailableParcelsResponseDto>> getAvailableParcels({
    @Query('date_from') required String dateFrom,
    @Query('date_to') required String dateTo,
    @Query('number_of_adults') required int numberOfAdults,
    @Query('number_of_children') required int numberOfChildren,
    @Query('page') required int page,
    @Query('page_size') required int pageSize,
  });

  @POST("/reservations/")
  Future<HttpResponse<void>> createReservation({
    @Body() required CreateReservationRequestDto createReservationRequestDto,
  });

  @GET("/reservations/user/")
  Future<HttpResponse<PaginatedResponse<ReservationPreviewDto>>>
      getMyReservations({
    @Query("page") required int page,
    @Query("user_id") required String userId,
  });

  @GET("/camping/sections/{camping_section__name}/plots/{position}/")
  Future<HttpResponse<ParcelDto>> getParcelDetails({
    @Path("camping_section__name") required String campingSectionName,
    @Path("position") required String position,
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

  @POST('s')
  Future<HttpResponse<String>> makeReservation();
}
