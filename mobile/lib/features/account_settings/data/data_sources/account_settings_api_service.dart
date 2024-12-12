import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/data/models/account_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_settings_api_service.g.dart';

@RestApi(baseUrl: "${Constants.apiUrl}/accounts")
abstract class AccountSettingsApiService {
  factory AccountSettingsApiService(Dio dio) = _AccountSettingsApiService;

  @GET("/details/{identifier}/")
  Future<HttpResponse<AccountDto>> getAccountDetails(
    @Path("identifier") String identifier,
  );
}
