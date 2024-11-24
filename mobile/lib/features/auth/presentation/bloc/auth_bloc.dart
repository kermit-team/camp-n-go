import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_state.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.authUseCase,
    required this.secureStorage,
  }) : super(const AuthInitial()) {
    on<Login>(
      (event, emit) => _login(event, emit),
    );
    on<SaveCredentials>((event, emit) => _saveCredentials(event, emit));
    on<LoadCredentials>((event, emit) => _loadCredentials(event, emit));
    on<DeleteCredentials>((event, emit) => _deleteCredentials(event, emit));
  }

  _login(Login event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      if (event.email.trim().isEmpty) {
        emit(const AuthEmailEmpty());
      }
      if (event.password.trim().isEmpty) {
        emit(const AuthPasswordEmpty());
      }
      add(SaveCredentials(
        email: event.email,
        password: event.password,
      ));

      final Result<AuthEntity, Exception> result = await authUseCase.call(
        params: AuthCredentials(
          email: event.email,
          password: event.password,
        ),
      );

      switch (result) {
        case Success<AuthEntity, Exception>(value: AuthEntity authEntity):
          {
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

  _saveCredentials(SaveCredentials event, Emitter<AuthState> emit) {
    if (event.email.trim().isNotEmpty && event.password.trim().isNotEmpty) {
      secureStorage.write(key: 'email', value: event.email);
      secureStorage.write(key: 'password', value: event.password);
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
      add(Login(
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
