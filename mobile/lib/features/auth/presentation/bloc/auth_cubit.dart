import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(const AuthState());

  Future<void> appStarted() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final result = await repository.initialLogin();
      switch (result) {
        case Success<AuthEntity, Exception>():
          emit(state.copyWith(status: AuthStatus.authenticated));
        case Failure<AuthEntity, Exception>(exception: Exception exception):
          emit(state.copyWith(
            status: AuthStatus.failure,
            exception: exception,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: exception,
      ));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    repository.logout();

    try {
      final Result<AuthEntity, Exception> result = await repository.login(
        params: AuthCredentials(
          email: email,
          password: password,
        ),
      );
      switch (result) {
        case Success<AuthEntity, Exception>():
          emit(state.copyWith(status: AuthStatus.authenticated));

        case Failure<AuthEntity, Exception>():
          emit(state.copyWith(
            status: AuthStatus.failure,
            exception: Exception(LocaleKeys.loginFailed.tr()),
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: exception,
      ));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final result = await repository.logout();
      switch (result) {
        case Success<void, Exception>():
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        case Failure<void, Exception>(exception: Exception exception):
          emit(state.copyWith(
            status: AuthStatus.failure,
            exception: exception,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        exception: exception,
      ));
    }
  }
}
