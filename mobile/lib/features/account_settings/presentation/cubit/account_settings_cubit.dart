import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final FlutterSecureStorage storage;

  AccountSettingsCubit({
    required this.storage,
  }) : super(const AccountSettingsState(status: AccountSettingsStatus.initial));

  editProperty({required AccountProperty property}) {
    emit(const AccountSettingsState(status: AccountSettingsStatus.loading));

    // final Result<AuthEntity, Exception> result = await authRepository.login(
    //   params: AuthCredentials(
    //     email: event.email,
    //     password: event.password,
    //   ),
    // );

    // switch (result) {
    //   case Success<AuthEntity, Exception>(value: AuthEntity authEntity):
    //     {
    //       add(SaveCredentials(
    //         email: event.email,
    //         password: event.password,
    //       ));
    //       emit(AuthSuccess(authEntity));
    //       serviceLocator<GoRouter>().go("/");
    //       emit(const AuthInitial());
    //     }
    //   case Failure<AuthEntity, Exception>(exception: final exception):
    //     {
    //       emit(AuthFailure(exception));
    //     }
    // }

    try {} on DioException catch (dioException) {
      // emit(AuthFailure(dioException));
    } on Exception catch (exception) {
      // emit(AuthFailure(exception));
    }
  }

  setLoading() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.loading));
  }

  setSuccess() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.success));
  }

  setError(Exception exception) {
    emit(AccountSettingsState(
      status: AccountSettingsStatus.error,
      exception: exception,
    ));
  }

  resetState() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.initial));
  }
}
