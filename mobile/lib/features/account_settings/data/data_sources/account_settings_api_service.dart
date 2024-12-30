import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/data/models/account_dto.dart';
import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:campngo/features/account_settings/data/models/modified_account_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_settings_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class AccountSettingsApiService {
  factory AccountSettingsApiService(Dio dio) = _AccountSettingsApiService;

  @GET("/accounts/{identifier}/")
  Future<HttpResponse<AccountDto>> getAccountDetails(
    @Path("identifier") String identifier,
  );

  @PATCH("/accounts/{identifier}/modify/")
  Future<HttpResponse<ModifiedAccountDto>> updateAccountProperty({
    @Path("identifier") required String identifier,
    @Body() required Map<String, dynamic> accountJson,
  });

  @PATCH("/accounts/{identifier}/modify/")
  Future<HttpResponse<ModifiedAccountDto>> updateAccountPassword({
    @Path("identifier") required String identifier,
    @Body() required Map<String, dynamic> passwordsJson,
  });

  @POST("/cars/add/")
  Future<HttpResponse<CarDto>> addCar({
    @Body() required Map<String, dynamic> registrationPlateJson,
  });

  @DELETE("/cars/{registration_plate}/remove-driver/")
  Future<HttpResponse<void>> deleteCar({
    @Path("registration_plate") required String registrationPlate,
  });

  @POST("/contact/{email}")
  Future<HttpResponse<void>> sendContactEmail({
    @Path("email") required String email,
    @Body() required Map<String, dynamic> content,
  });
}
