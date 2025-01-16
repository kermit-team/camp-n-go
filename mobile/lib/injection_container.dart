import 'package:campngo/core/interceptors/token_interceptor.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/data/data_sources/account_settings_api_service.dart';
import 'package:campngo/features/account_settings/data/repository_impl/account_settings_repository_impl.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/cubit/contact_form_cubit.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:campngo/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:campngo/features/register/data/data_sources/register_api_service.dart';
import 'package:campngo/features/register/data/repository_impl/register_repository_impl.dart';
import 'package:campngo/features/register/domain/repository/register_repository.dart';
import 'package:campngo/features/register/domain/use_cases/register_use_case.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/reservations/data/data_sources/reservation_api_service.dart';
import 'package:campngo/features/reservations/data/repository_impl/reservation_repository_impl.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:campngo/features/reservations/presentation/cubit/parcel_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_preview_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Create dependencies
  const secureStorage = FlutterSecureStorage();
  const tokenStorage = TokenStorage(secureStorage);
  final dio = _createDio(tokenStorage);
  final authApiService = AuthApiService(dio);
  final authRepository = AuthRepositoryImpl(
    authApiService,
    secureStorage,
    tokenStorage,
  );
  final authCubit = AuthCubit(authRepository);

  final registerApiService = RegisterApiService(dio);
  final registerRepository = RegisterRepositoryImpl(registerApiService);
  final registerUseCase = RegisterUseCase(registerRepository);
  final accountSettingsApiService = AccountSettingsApiService(dio);
  final accountSettingsRepository =
      AccountSettingsRepositoryImpl(accountSettingsApiService);
  final reservationApiService = ReservationApiService(dio);
  final reservationRepository =
      ReservationRepositoryImpl(reservationApiService, useMocks: false);

  // Register dependencies
  serviceLocator.registerSingleton<Dio>(dio);
  serviceLocator.registerLazySingleton(() => secureStorage);
  serviceLocator.registerSingleton(tokenStorage);
  serviceLocator.registerSingleton<AuthApiService>(authApiService);
  serviceLocator.registerSingleton<AuthRepository>(authRepository);
  serviceLocator.registerSingleton<AuthCubit>(authCubit);
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
  serviceLocator
      .registerSingleton<AccountSettingsApiService>(accountSettingsApiService);
  serviceLocator
      .registerSingleton<AccountSettingsRepository>(accountSettingsRepository);
  serviceLocator.registerFactory(
    () => AccountSettingsCubit(
      accountSettingsRepository: accountSettingsRepository,
      storage: secureStorage,
    ),
  );
  serviceLocator.registerFactory(
    () => ContactFormCubit(
      accountSettingsRepository: accountSettingsRepository,
    ),
  );
  serviceLocator
      .registerSingleton<ReservationApiService>(reservationApiService);
  serviceLocator
      .registerSingleton<ReservationRepository>(reservationRepository);
  serviceLocator.registerFactory(
    () => ReservationPreviewCubit(
      reservationRepository: reservationRepository,
    ),
  );
  serviceLocator.registerFactory(
    () => ParcelListCubit(reservationRepository: reservationRepository),
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
