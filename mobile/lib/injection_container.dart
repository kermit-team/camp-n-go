import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio();
  //todo: add go_router to injection container
  serviceLocator.registerSingleton(dio);
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());
  serviceLocator.registerSingleton(AuthApiService(serviceLocator<Dio>()));
}
