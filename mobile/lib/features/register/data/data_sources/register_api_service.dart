import 'package:campngo/config/constants.dart';
import 'package:campngo/features/register/data/models/register_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'register_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class RegisterApiService {
  factory RegisterApiService(Dio dio) = _RegisterApiService;

  @POST('/accounts/register/')
  Future<HttpResponse<RegisterDTO>> register({
    @Body() required Map<String, dynamic> userData,
  });

  @POST('/accounts/password-reset/')
  Future<HttpResponse<dynamic>> forgotPassword({
    @Body() required Map<String, dynamic> email,
  });
}
