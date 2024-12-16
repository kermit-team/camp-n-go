import 'package:campngo/config/constants.dart';
import 'package:campngo/features/auth/data/models/auth_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST('/accounts/token/')
  Future<HttpResponse<AuthResponseDTO>> login({
    @Body() required Map<String, dynamic> credentials,
  });

  @POST("/accounts/token/refresh/")
  Future<HttpResponse<String>> refreshAccessToken({
    @Body() required Map<String, dynamic> refreshToken,
  });
}
