import 'package:campngo/config/constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_api_service.g.dart';

@RestApi(baseUrl: Constants.apiUrl)
abstract class ReservationApiService {
  factory ReservationApiService(Dio dio) = _ReservationApiService;
}
