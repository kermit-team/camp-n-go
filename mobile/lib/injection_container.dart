import 'package:campngo/config/routes/app_router.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );

  serviceLocator.registerSingleton<Dio>(dio);
  serviceLocator.registerSingleton<GoRouter>(AppRouter().router);
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());

  serviceLocator
      .registerSingleton<AuthApiService>(AuthApiService(serviceLocator<Dio>()));
}
