import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_state.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.authRepository,
    required this.secureStorage,
  }) : super(const AuthInitial()) {
    on<Login>((event, emit) => _login(event, emit));
    on<InitialLogin>((event, emit) => _initialLogin(event, emit));
    on<SaveCredentials>((event, emit) => _saveCredentials(event, emit));
    on<LoadCredentials>((event, emit) => _loadCredentials(event, emit));
    on<DeleteCredentials>((event, emit) => _deleteCredentials(event, emit));
  }

  _login(Login event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    add(DeleteCredentials());

    try {
      if (event.email.trim().isEmpty) {
        emit(const AuthEmailEmpty());
        return;
      }
      if (event.password.trim().isEmpty) {
        emit(const AuthPasswordEmpty());
        return;
      }

      final Result<AuthEntity, Exception> result = await authRepository.login(
        params: AuthCredentials(
          email: event.email,
          password: event.password,
        ),
      );

      switch (result) {
        case Success<AuthEntity, Exception>(value: AuthEntity authEntity):
          {
            add(SaveCredentials(
              email: event.email,
              password: event.password,
              accessToken: authEntity.accessToken,
              refreshToken: authEntity.refreshToken,
            ));
            emit(AuthSuccess(authEntity));
            serviceLocator<GoRouter>().go("/");
            emit(const AuthInitial());
          }
        case Failure<AuthEntity, Exception>(exception: final exception):
          {
            emit(AuthFailure(exception));
          }
      }
    } on DioException catch (dioException) {
      emit(AuthFailure(dioException));
    } on Exception catch (exception) {
      emit(AuthFailure(exception));
    }
  }

  _initialLogin(InitialLogin event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final storageEmail = await secureStorage.read(key: 'email');
    final storagePassword = await secureStorage.read(key: 'password');
    if (storageEmail == null || storagePassword == null) {
      emit(const AuthInitial());
      return;
    } else {
      emit(AuthCredentialsLoaded(
        email: storageEmail,
        password: storagePassword,
      ));

      try {
        final Result<AuthEntity, Exception> result =
            await authRepository.initialLogin(
          params: AuthCredentials(
            email: storageEmail,
            password: storagePassword,
          ),
        );

        switch (result) {
          case Success<AuthEntity, Exception>(value: AuthEntity authEntity):
            {
              add(
                SaveCredentials(
                  accessToken: authEntity.accessToken,
                  refreshToken: authEntity.refreshToken,
                  email: storageEmail,
                  password: storagePassword,
                ),
              );
              emit(AuthSuccess(authEntity));
              serviceLocator<GoRouter>().go("/");
              emit(const AuthInitial());
            }
          case Failure<AuthEntity, Exception>(exception: final exception):
            {
              emit(AuthFailure(exception));
            }
        }
      } on DioException catch (dioException) {
        emit(AuthFailure(dioException));
      } on Exception catch (exception) {
        emit(AuthFailure(exception));
      }
    }
  }

  _saveCredentials(SaveCredentials event, Emitter<AuthState> emit) async {
    if (event.email.trim().isNotEmpty && event.password.trim().isNotEmpty) {
      secureStorage.write(key: 'email', value: event.email);
      secureStorage.write(key: 'password', value: event.password);
      await serviceLocator<TokenStorage>().saveTokens(
        accessToken: event.accessToken,
        refreshToken: event.refreshToken,
      );
    }
  }

  _loadCredentials(LoadCredentials event, Emitter<AuthState> emit) async {
    final storageEmail = await secureStorage.read(key: 'email');
    final storagePassword = await secureStorage.read(key: 'password');
    if (storageEmail != null && storagePassword != null) {
      emit(AuthCredentialsLoaded(
        email: storageEmail,
        password: storagePassword,
      ));
    }
  }

  _deleteCredentials(DeleteCredentials event, Emitter<AuthState> emit) async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
  }
}
