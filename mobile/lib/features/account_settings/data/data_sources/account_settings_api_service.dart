import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/data/models/account_dto.dart';
import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_settings_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class AccountSettingsApiService {
  factory AccountSettingsApiService(Dio dio) = _AccountSettingsApiService;

  @GET("/accounts/details/{identifier}/")
  Future<HttpResponse<AccountDto>> getAccountDetails(
    @Path("identifier") String identifier,
  );

  @POST("/cars/add/")
  Future<HttpResponse<CarDto>> addCar({
    @Body() required String registrationPlate,
  });

  @DELETE("/cars/remote-driver/{registration_plate}/")
  Future<HttpResponse<CarDto>> deleteCar({
    @Path("registration_plate") required String registrationPlate,
  });
}
