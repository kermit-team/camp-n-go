import 'package:campngo/config/routes/app_router.dart';
import 'package:campngo/core/interceptors/token_interceptor.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/data/data_sources/account_settings_api_service.dart';
import 'package:campngo/features/account_settings/data/repository_impl/account_settings_repository_impl.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:campngo/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campngo/features/register/data/data_sources/register_api_service.dart';
import 'package:campngo/features/register/data/repository_impl/register_repository_impl.dart';
import 'package:campngo/features/register/domain/repository/register_repository.dart';
import 'package:campngo/features/register/domain/use_cases/register_use_case.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Create dependencies
  final router = AppRouter().router;
  const secureStorage = FlutterSecureStorage();
  const tokenStorage = TokenStorage(secureStorage);
  final dio = _createDio(tokenStorage);
  final authApiService = AuthApiService(dio);
  final authRepository = AuthRepositoryImpl(authApiService);
  final registerApiService = RegisterApiService(dio);
  final registerRepository = RegisterRepositoryImpl(registerApiService);
  final registerUseCase = RegisterUseCase(registerRepository);
  final accountSettingsApiService = AccountSettingsApiService(dio);
  final accountSettingsRepository =
      AccountSettingsRepositoryImpl(accountSettingsApiService);

  // Register dependencies
  serviceLocator.registerSingleton<Dio>(dio);
  serviceLocator.registerSingleton<GoRouter>(router);
  serviceLocator.registerLazySingleton(() => secureStorage);
  serviceLocator.registerSingleton(tokenStorage);
  serviceLocator.registerSingleton<AuthApiService>(authApiService);
  serviceLocator.registerSingleton<AuthRepository>(authRepository);
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: authRepository,
      secureStorage: secureStorage,
    ),
  );
  serviceLocator.registerSingleton<RegisterApiService>(registerApiService);
  serviceLocator.registerSingleton<RegisterRepository>(registerRepository);
  serviceLocator.registerSingleton<RegisterUseCase>(registerUseCase);
  serviceLocator.registerFactory(
    () => RegisterBloc(
      registerUseCase: registerUseCase,
      secureStorage: secureStorage,
    ),
  );
  serviceLocator.registerFactory(
    () => ForgotPasswordBloc(
      registerRepository: registerRepository,
      secureStorage: secureStorage,
    ),
  );
  serviceLocator.registerFactory(
    () => AccountSettingsCubit(
      accountSettingsRepository: accountSettingsRepository,
      storage: secureStorage,
    ),
  );
}

Dio _createDio(TokenStorage tokenStorage) {
  final dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
  dio.interceptors.add(TokenInterceptor(
    tokenStorage: tokenStorage,
    dio: dio,
  ));
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );
  return dio;
}
