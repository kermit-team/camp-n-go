import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/paginated_response.dart';
import 'package:campngo/features/reservations/data/models/available_parcels_response_dto.dart';
import 'package:campngo/features/reservations/data/models/create_reservation_request_dto.dart';
import 'package:campngo/features/reservations/data/models/create_reservation_response_dto.dart';
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

  //ready
  @GET("/camping/plots/available/")
  Future<HttpResponse<AvailableParcelsResponseDto>> getAvailableParcels({
    @Query('date_from') required String dateFrom,
    @Query('date_to') required String dateTo,
    @Query('number_of_adults') required int numberOfAdults,
    @Query('number_of_children') required int numberOfChildren,
    @Query('page') required int page,
    @Query('page_size') required int pageSize,
  });

  //to test
  @GET("/camping/reservations/")
  Future<HttpResponse<PaginatedResponse<ReservationPreviewDto>>>
      getMyReservations({
    @Query("page") required int page,
    @Query("page_size") required int pageSize,
  });

  //to test
  @GET("/camping/plots/{id}/")
  Future<HttpResponse<ParcelDto>> getParcelDetails({
    @Path("id") required int id,
  });

  //to test
  @GET("/camping/reservations/{id}/details/")
  Future<HttpResponse<ReservationDto>> getReservationDetails({
    @Path("id") required int reservationId,
  });

  //to test
  @PATCH("/camping/reservations/{id}/modify/car/")
  Future<HttpResponse<void>> updateReservation({
    @Path("id") required int reservationId,
    @Body() required UpdateReservationRequestDto updateReservationRequestDto,
  });

  //to test
  @PATCH("/camping/reservations/{id}/cancel/")
  Future<HttpResponse<void>> cancelReservation({
    @Path('id') required int reservationId,
  });

  @POST('/camping/reservations/create/')
  Future<HttpResponse<CreateReservationResponseDto>> createReservation({
    @Body() required CreateReservationRequestDto createReservationRequestDto,
  });

  @PUT("/camping/reservations/{id}/modify/car/")
  Future<HttpResponse<void>> editCar({
    @Path("id") required int reservationId,
    @Body() required Map<String, dynamic> carId,
  });
}
