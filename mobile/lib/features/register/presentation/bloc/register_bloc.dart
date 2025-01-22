import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:campngo/features/register/domain/use_cases/register_use_case.dart';
import 'package:campngo/features/register/presentation/bloc/register_event.dart';
import 'package:campngo/features/register/presentation/bloc/register_state.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final FlutterSecureStorage secureStorage;

  RegisterBloc({
    required this.registerUseCase,
    required this.secureStorage,
  }) : super(const RegisterInitial()) {
    on<Register>((event, emit) => _register(event, emit));
  }

  _register(Register event, Emitter<RegisterState> emit) async {
    emit(const RegisterLoading());

    try {
      if (event.firstName.trim().isEmpty) {
        emit(const RegisterFirstNameEmpty());
      }
      if (event.lastName.trim().isEmpty) {
        emit(const RegisterLastNameEmpty());
      }
      if (event.email.trim().isEmpty) {
        emit(const RegisterEmailEmpty());
      }
      if (event.password.trim().isEmpty) {
        emit(const RegisterPasswordEmpty());
      }
      if (event.confirmPassword.trim().isEmpty) {
        emit(const RegisterConfirmPasswordEmpty());
      }
      if (event.password != event.confirmPassword) {
        emit(const RegisterPasswordsNotMatch());
      }
      final Result<RegisterEntity, Exception> result =
          await registerUseCase.call(
        params: RegisterEntity(
          email: event.email,
          password: event.password,
          profile: AccountProfile(
            firstName: event.firstName,
            lastName: event.lastName,
          ),
        ),
      );

      switch (result) {
        case Success<RegisterEntity, Exception>(
            value: RegisterEntity registerEntity,
          ):
          {
            emit(RegisterSuccess(registerEntity));
          }
        case Failure<RegisterEntity, Exception>(exception: final exception):
          {
            emit(RegisterFailure(
              Exception(LocaleKeys.registerFailed.tr()),
            ));
          }
      }
    } on DioException catch (dioException) {
      emit(RegisterFailure(dioException));
    } on Exception catch (exception) {
      emit(RegisterFailure(exception));
    }
  }
}
